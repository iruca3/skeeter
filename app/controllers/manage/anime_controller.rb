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
    @edit_anime = Anime.find( params[:id] )
    @users = User.find_all_enabled()

    if params[:mode] == 'edit'
      if params[:commit] == '保存する'
        # アカウント情報を保存する。
        @edit_anime.title = params[:title]
        @edit_anime.owner_id = params[:owner_id]
        @edit_anime.story_number = params[:story_number]
        @edit_anime.status = params[:status]
        @edit_anime.description = params[:description]

        if @edit_anime.title == ''
          @error = '入力値に不備があります。'
          return

        end

        if @edit_anime.save
          @info = 'アニメ情報を保存しました。'

        else
          @error = 'アニメ情報の保存に失敗しました。'

        end

      elsif params[:commit] == '削除する'
        Anime.destroy( params[:id] )
        redirect_to :action => 'index'
        return

      end

    end

  end

  # アニメの新規作成を行う。
  # パラメータ mode が create の場合、渡されたパラメータ情報を元に
  # アカウント情報を作成する。
  public
  def new
    @new_anime = Anime.new
    @users = User.find_all_enabled()

    if params[:mode] == 'create'
      # アカウント情報を作成する。
      @new_anime.title = params[:title]
      @new_anime.owner_id = params[:owner_id]
      @new_anime.story_number = params[:story_number]
      @new_anime.status = params[:status]
      @new_anime.description = params[:description]

      # 入力値チェック
      if @new_anime.title == ''
        @error = '入力値に不備があります。'
        return

      end

      if @new_anime.save
        @info = '新しいアニメを作成しました。'
        @new_anime = Anime.new

      else
        @error = 'アニメの作成に失敗しました。'

      end

    end

  end

end
