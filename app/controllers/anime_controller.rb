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
