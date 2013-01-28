# -*- coding: utf-8 -*-

# = アニメコントローラ
# Author:: Dolphin
# Date:: 2013.01.27
#
class AnimeController < ApplicationController

  def edit
    if params[:id] == nil
      redirect_to :controller => '/my'
      return
      
    end

    if session['info'] != nil
      @info = session[:info]
      session['info'] = nil
      
    end

    @anime = Anime.find( params[:id] )

    # アクセス権限チェック
    # 作品責任者 or システム管理者のみアクセスを許可。
    if @anime.owner.id != @user.id && @user.account_type != User::TYPE_ADMIN
      redirect_to :controller => '/my'
      return

    end

    if params[:mode] == 'edit'
      if params[:commit] == '保存する'
        # アカウント情報を保存する。
        @anime.title = params[:title]
        @anime.owner_id = params[:owner_id] if @user.account_type == User::TYPE_ADMIN
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
            @info = 'アニメ情報を保存しました。'

          else
            @error = 'アニメ情報の保存に失敗しました。'

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

  # アニメにストーリーを追加する。
  def ajax_add_episode
    return if params[:episode_name] == '' || params[:episode_name] == nil
    @anime = Anime.find( params[:id] )
    return if @anime == nil

    # アクセス権限チェック
    # 作品責任者 or システム管理者のみアクセスを許可。
    return if @anime.owner.id != @user.id && @user.account_type != User::TYPE_ADMIN

    @episode = Episode.add( @anime, params[:episode_name] )

  end


end
