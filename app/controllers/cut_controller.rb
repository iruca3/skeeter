# -*- coding: utf-8 -*-

require 'kconv'

# = カットコントローラ
# Author:: Dolphin
# Date:: 2013.01.29
#
class CutController < ApplicationController

  # 指定されたカット番号の次のカット番号を計算する。
  # 英字が入っている場合は、英字を除去した番号の次の番号を返す。
  #
  # === 返り値
  # [integer] カット番号
  # 
  private
  def calc_next_number( cut_number )
    if cut_number[-1] =~ /\d/
      # 末尾は数値なので、数値化して1加算する
      cut_number = cut_number.to_i + 1
    else
      # 末尾は英字なので、英字を除去して1加算する
      cut_number = cut_number.gsub!(/[^\d]/,'').to_i + 1
    end

    return cut_number

  end
  
  # 数値部分の桁数を計算する。
  #
  # === 返り値
  # [integer] 桁数
  # 
  private
  def calc_digits( cut_number )
    if cut_number[-1] =~ /\d/
      # 末尾は数値なので、そのまま返す。
      return cut_number.length
    else
      # 末尾は英字なので、英字を除去して文字数を数える。
      return cut_number.gsub!(/[^\d]/,'').length
    end
    
  end

  # カットの追加処理
  private
  def add_cut( episode_id, number, cut_part_id, picture, memo )
    Cut.create(
      :episode_id => episode_id,
      :number => number,
      :cut_part_id => cut_part_id,
      :picture => picture,
      :memo => memo
    )

  end

  # カットを追加する
  public
  def add
    redirect_to :controller => 'my' and return if params[:id].blank?
    @episode = Episode.find_by_id( params[:id] )
    redirect_to :controller => 'my' and return if @episode.nil?

    # アクセス権限チェック
    # システム管理者か、監督の必要あり。
    redirect_to :controller => 'my' and return if ( @episode.director.nil? || @episode.director.id != @user.id ) && ( ! @user.is_admin? ) 

    add_cut_number = Array.new
    first_added_num = ''
    last_added_num = ''
    if params[:mode] == 'add'
      redirect_to :controller => 'episode', :action => 'index', :id => @episode.id and return if params[:add_number].to_i <= 0
      # カット番号を指定して追加
      redirect_to :controller => 'episode', :action => 'index', :id => @episode.id and return if params[:number].blank?

      # 桁数を計算する。
      digits = 3
      if @episode.cut.count > 0
        digits = calc_digits( @episode.cut.last.number )
      end

      # カットを追加する。
      cut_number = params[:number]
      if cut_number[-1] =~ /\d/
        # 数値の場合
        cut_number = cut_number.to_i
        (cut_number .. ( cut_number + params[:add_number].to_i - 1 )).each do |i|
          num = "%0#{digits}d" % i
          first_added_num = num if first_added_num.blank?
          last_added_num = num
          add_cut_number.push( num )
          
        end

      else
        # 数値＋英字の場合
        # 英字を増やしていく。
        suffix = cut_number.gsub(/[\d]/,'')
        prefix = cut_number.gsub(/[^\d]/,'').to_i
        prefix = "%0#{digits}d" % prefix
        (0 .. ( params[:add_number].to_i - 1 )).each do |i|
          # 末尾文字の英字のアスキーコードを 1 増やしていく。
          suffix[-1] = (suffix[-1].bytes.to_a[0] + 1).chr if i > 0
          num = prefix + suffix
          first_added_num = num if first_added_num.blank?
          last_added_num = num
          add_cut_number.push( num )

        end
        
      end

    elsif params[:mode] == 'add_last'
      redirect_to :controller => 'episode', :action => 'index', :id => @episode.id and return if params[:add_number].to_i <= 0

      # 末尾に追加
      # 追加するカット番号を計算する。
      cut_number = ''
      if @episode.cut.count <= 0
        cut_number = 1
        digits = 3
      else
        cut_number = calc_next_number( @episode.cut.last.number )
        digits = calc_digits( @episode.cut.last.number )
      end

      # 追加処理を行う。
      (cut_number .. ( cut_number + params[:add_number].to_i - 1 )).each do |i|
        num = "%0#{digits}d" % i
        first_added_num = num if first_added_num.blank?
        last_added_num = num
        add_cut_number.push( num )

      end

    elsif params[:mode] == 'add_by_zip'
      redirect_to :controller => 'episode', :action => 'index', :id => @episode.id and return if params[:zip_file].blank?

      @cuts = Array.new
      @error_files = Array.new
      @created_cuts = Array.new
      @updated_cuts = Array.new
      @error = ''
      archive_file = params[:zip_file]
      begin
        Zip::Archive.open_buffer( archive_file.read ) do |ar|
          ar.each do |file|
            unless file.directory?
              ext = File.extname( file.name )[1..-1]
              cut_name = file.name[0,file.name.length-ext.length-1]
              cut_name = File.basename( cut_name )

              # ファイル名からカット番号を計算する。
              # 計算できない場合(所定のフォーマットではない場合)、無視する。
              unless cut_name =~ /^[0-9]+[a-zA-Z]?$/              
                @error_files.push( file.name )
                next
              end

              # ファイルをMD5ハッシュ値の名前で保存する。
              temp_file = Tempfile.open( 'picture', Rails.root.join('tmp') )
              temp_file.binmode
              temp_file.print( file.read )
              temp_file.close
              file_md5 = CryptHelper::make_md5_by_file( temp_file.path )
              picture_path = Rails.root.join( "data/picture/#{file_md5}.#{ext}" )
              
              unless File.exists?( picture_path )
                FileUtils.move( temp_file.path, picture_path )
              end
              picture_filename = "#{file_md5}.#{ext}"
              
              # カット番号が存在しない場合、新しく追加する。
              ret = Cut.find_by_number( @episode, cut_name )
              if ret.nil?
                Cut.create( :episode_id => @episode.id, :number => cut_name, :cut_part_id => nil, :picture => picture_filename, :memo => '' )
                @created_cuts.push( cut_name )

              else
                # カット番号が既に存在している場合、ピクチュアが更新されているかチェックする。
                if ret.picture != picture_filename
                  # ピクチュアが更新されていれば、上書き保存する。
                  old_picture = ret.picture
                  ret.picture = picture_filename
                  ret.save
                  @updated_cuts.push( cut_name )

                  # さらに、更新前のピクチュアが他で使用されていなければ、ファイルを削除する。
                  if Cut.find( :all, :conditions => { :picture => old_picture } ).count == 0
                    Fileutils.rm( Rails.root.join( "data/picture/#{old_picture}" ) )
                  end

                end

              end

            
            end

          end

        end

      rescue
        @error = 'ZIPファイルの解析に失敗しました。<br />ZIPファイル以外のファイルはアップしないでください。<br />(日本語などが含まれるファイル・フォルダは入れないでください。)'

      end

      message = ''
      if @updated_cuts.count > 0 || @created_cuts.count > 0
        message += 'カットを作成・更新しました。<br />'
      else
        message += 'カットの作成・更新は行われませんでした。<br />' + @error + '<br />'
      end
      if @created_cuts.count > 0
        message += '作成されたカット: ' + @created_cuts.join(',') + '<br />'
      end
      if @updated_cuts.count > 0
        message += '更新されたカット: ' + @updated_cuts.join(',') + '<br />'
      end
      if @error_files.count > 0
        message += 'エラーファイル: ' + @error_files.join(',').kconv(Kconv::UTF8,Kconv::SJIS) + '<br />'
      end
      session['info'] = message
      redirect_to :controller => 'episode', :action => 'index', :id => @episode.id
      return

    end

    # 重複するカット番号がないか調べる
    if @episode.contain_cut( add_cut_number )
      session['error'] = '既に同じカット番号が存在します。' + add_cut_number.join(',')
      redirect_to :controller => 'episode', :action => 'index', :id => @episode.id
      return
    end

    add_cut_number.each do |num|
      add_cut( @episode.id, num, params[:cut_part_id].to_i, '', '' ) 
    end

    if first_added_num.blank?
      session['error'] = 'カットを追加できませんでした。'
    else
      if first_added_num == last_added_num
        session['info'] = 'カットを追加しました。(' + first_added_num + ')'
      else
        session['info'] = 'カットを追加しました。(' + first_added_num + ' .. ' + last_added_num + ')'
      end
    end

    redirect_to :controller => 'episode', :action => 'index', :id => @episode.id
    return

  end

  # ピクチュアを画像データとして返す。
  def picture
    cut = Cut.find_by_id( params[:id] )

    # アクセス権限のチェック
    unless cut.episode.contain_member( @user ) || @user.is_admin?
      send_data( open( 'data/picture/blank.png', 'rb' ).read, :type => 'image/png', :disposition => 'inline' )
      return
    end

    if cut.picture.blank?
      send_data( open( 'data/picture/blank.png', 'rb' ).read, :type => 'image/png', :disposition => 'inline' )
      return
    end

    send_data( open( 'data/picture/' + cut.picture, 'rb' ).read, :type => 'image/png', :disposition => 'inline' )
    return

  end

end
