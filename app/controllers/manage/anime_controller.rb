# -*- coding: utf-8 -*-

# = アニメ管理コントローラ
# Author:: Dolphin
# Date:: 2013.01.27
#
class Manage::AnimeController < ApplicationController
  before_filter :access_check

  # アクセス権限チェックを実施する。
  # アクセス権限がない場合、マイページへ遷移する。
  private
  def access_check
    unless @user.is_admin?
      redirect_to :controller => '/my'
      return

    end
    
  end

  # アニメ管理ページを表示する。
  public
  def index
    @animes = Anime.find( :all, :order => 'id' )
    
  end

  # アニメ情報の編集ページを表示する。
  # パラメータ mode が edit の場合、渡されたパラメータ情報を元に
  # アニメ情報を更新する。
  public
  def edit
    @anime = Anime.find( params[:id] )
    if session['info'] != nil
      @info = session['info']
      session['info'] = nil
    end

    if params[:mode] == 'edit'
      if params[:commit] == '保存する'
        # アカウント情報を保存する。
        @anime.title = params[:title]
        @anime.owner_id = params[:owner_id]
        @anime.total_episode_number = params[:total_episode_number]
        @anime.status = params[:status]
        @anime.description = params[:description]

        if @anime.title == ''
          @error = '入力値に不備があります。'
          return

        end

        if @anime.save
          @info = 'アニメ情報を保存しました。'

        else
          @error = 'アニメ情報の保存に失敗しました。'

        end

      elsif params[:commit] == '削除する'
        Anime.destroy( params[:id] )
        redirect_to :action => 'index'
        return

      end

    elsif params[:mode] == 'edit_episode'
      @episode = Episode.find( params[:episode_id] )
      if params[:commit] == '保存する'
        if @episode != nil
          @episode.title = params[:title]
          @episode.director_id = params[:director_id]
          @episode.episode_number = params[:episode_number]
          @episode.description = params[:description]
          @episode.status = params[:status]
          @episode.deadline = params[:deadline]

          if @episode.title == ''
            @error = '入力値に不備があります。'
            return

          end

          if @episode.save
            @info = 'エピソード情報を保存しました。'

          else
            @error = 'エピソード情報の保存に失敗しました。'

          end

        end

      elsif params[:commit] == '削除する'
      Episode.destroy( params[:episode_id] )
      session['info'] = 'アニメ「' + @episode.title + '」を削除しました。'
        redirect_to :action => 'edit', :id => params[:id]
        return

      end

    end

    if params[:episode_id] == '' || params[:episode_id] == nil
      params[:episode_id] = @anime.episode.last.id if @anime.episode.count > 0
    else
      params[:mode] = 'edit_episode'
    end
    @episode = Episode.find( params[:episode_id] ) if params[:episode_id] != nil

  end

  # アニメの新規作成を行う。
  # パラメータ mode が create の場合、渡されたパラメータ情報を元に
  # アカウント情報を作成する。
  public
  def new
    @anime = Anime.new

    if params[:mode] == 'create'
      # アカウント情報を作成する。
      @anime.title = params[:title]
      @anime.owner_id = params[:owner_id]
      @anime.total_episode_number = params[:total_episode_number]
      @anime.status = params[:status]
      @anime.description = params[:description]

      # 入力値チェック
      if @anime.title == ''
        @error = '入力値に不備があります。'
        return

      end

      if @anime.save
        session['info'] = '新しいアニメを作成しました。'
        redirect_to :action => 'edit', :id => @anime.id

      else
        @error = 'アニメの作成に失敗しました。'

      end

    end

  end


  # アニメにストーリーを追加する。
  def ajax_add_episode
    if params[:episode_name] != '' && params[:episode_name] != nil
      @anime = Anime.find( params[:id] )
      if @anime != nil
        @episode = Episode.add( @anime, params[:episode_name] )

      end

    end

    render 'anime/ajax_add_episode'
    return

  end

  # メンバーを追加する。
  public
  def ajax_add_episode_member
    @episode = Episode.find( params[:episode_id] )
    @member = EpisodeMember.add_member( @episode, params[:user_id], params[:role] )

    render 'anime/ajax_add_episode_member'
    return

  end

  # メンバーを削除する。
  public
  def ajax_remove_episode_member
    @episode = Episode.find( params[:episode_id] )
    @result = false

    @member = nil
    @episode.member.each do |member|
      if member.user.id == params[:user_id].to_i 
        @member = member
        break
      end
    end
    if @member != nil
      @result = EpisodeMember.remove_member( @episode, params[:user_id] )
    
    end

    render 'anime/ajax_remove_episode_member'
    return

  end

  # カットパートを追加する。
  def ajax_add_cut_part
    return if params[:name] == '' || params[:name] == nil
    @anime = Anime.find_by_id( params[:id] )
    return if @anime.nil?

    @cut_part = CutPart.add( params[:episode_id], params[:name] )

    render 'anime/ajax_add_cut_part'
    return

  end

  # カットパートを削除する。
  def ajax_remove_cut_part
    return if params[:cut_part_id].nil?
    @cut_part = CutPart.find_by_id( params[:cut_part_id] )
    return if @cut_part.nil?

    @cut_part.remove

    render 'anime/ajax_remove_cut_part'
    return

  end

  # カットパートを上に移動する。
  def ajax_up_cut_part
    return if params[:cut_part_id].nil?
    @cut_part = CutPart.find_by_id( params[:cut_part_id] )
    return if @cut_part.nil?

    @sort_from = @cut_part.sort
    @cut_part.move_up
    @sort_to = @cut_part.sort

    render 'anime/ajax_up_cut_part'
    return

  end
  
  # カットパートを下に移動する。
  def ajax_down_cut_part
    return if params[:cut_part_id].nil?
    @cut_part = CutPart.find_by_id( params[:cut_part_id] )
    return if @cut_part.nil?

    @sort_from = @cut_part.sort
    @cut_part.move_down
    @sort_to = @cut_part.sort

    render 'anime/ajax_down_cut_part'
    return

  end


end
