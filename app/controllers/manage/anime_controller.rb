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
    if @user.account_type != User::TYPE_ADMIN
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

      elsif params[:commit] == '削除する'
        Anime.destroy( params[:id] )
        redirect_to :action => 'index'
        return

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
      @anime.story_number = params[:story_number]
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
  def ajax_add_story
    return if params[:story_name] == '' || params[:story_name] == nil
    @anime = Anime.find( params[:id] )
    return if @anime == nil
    @story = Story.add( @anime, params[:story_name] )

  end

end
