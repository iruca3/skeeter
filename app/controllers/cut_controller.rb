# -*- coding: utf-8 -*-

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

  # カットを追加する
  public
  def add
    redirect_to :controller => 'my' and return if params[:id].blank?
    @episode = Episode.find_by_id( params[:id] )
    redirect_to :controller => 'my' and return if @episode.nil?
    redirect_to :controller => 'episode', :action => 'index', :id => @episode.id if params[:add_number].to_i <= 0

    # アクセス権限チェック
    # システム管理者か、監督の必要あり。
    redirect_to :controller => 'my' if ( @episode.director.nil? || @episode.director.id != @user.id ) && ( ! @user.is_admin? ) 

    if params[:mode] == 'add'
    elsif params[:mode] == 'add_last'
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
      first_added_num = ''
      last_added_num = ''
      (cut_number .. (cut_number+params[:add_number].to_i-1)).each do |i|
        num = "%0#{digits}d" % i
        first_added_num = num if first_added_num.blank?
        last_added_num = num
        Cut.create(
          :episode_id => @episode.id,
          :number => num,
          :cut_part_id => params[:cut_part_id].to_i,
          :picture => '',
          :memo => ''
        )
      end

      if first_added_num.blank?
        session['error'] = 'カットを追加できませんでした。'
      else
        session['info'] = 'カットを追加しました。(' + first_added_num + ' .. ' + last_added_num + ')'
      end

      redirect_to :controller => 'episode', :action => 'index', :id => @episode.id
      
    end

  end

end
