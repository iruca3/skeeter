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
        @anime.story_number = params[:story_number]
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
    elsif params[:mode] == 'edit_story'
      @story = Story.find( params[:story_id] )
      if params[:commit] == '保存する'
        if @story != nil
          @story.title = params[:title]
          @story.director_id = params[:director_id]
          @story.episode = params[:episode]
          @story.description = params[:description]
          @story.status = params[:status]
          @story.deadline = params[:deadline]

          if @story.title == ''
            @error = '入力値に不備があります。'
            return

          end

          if @story.save
            @info = 'アニメ情報を保存しました。'

          else
            @error = 'アニメ情報の保存に失敗しました。'

          end

        end

      elsif params[:commit] == '削除する'
        Story.destroy( params[:story_id] )
        session['info'] = 'アニメ「' + @story.title + '」を削除しました。'
        redirect_to :action => 'edit', :id => params[:id]
        return

      end

    end

    if params[:story_id] == '' || params[:story_id] == nil
      params[:story_id] = @anime.story[0].id if @anime.story.count > 0
    end
    @story = Story.find( params[:story_id] ) if params[:story_id] != nil

  end

  # アニメにストーリーを追加する。
  def ajax_add_story
    return if params[:story_name] == '' || params[:story_name] == nil
    @anime = Anime.find( params[:id] )
    return if @anime == nil

    # アクセス権限チェック
    # 作品責任者 or システム管理者のみアクセスを許可。
    return if @anime.owner.id != @user.id && @user.account_type != User::TYPE_ADMIN

    @story = Story.add( @anime, params[:story_name] )

  end


end
