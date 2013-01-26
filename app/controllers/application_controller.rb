# -*- coding: utf-8 -*-

# = アプリケーションコントローラ
# Author:: Dolphin
# Date:: 2013.01.26
#
# 全てのコントローラの継承元である。
# 認証が必要なページについては、認証処理を行う。
#
# === インスタンス変数
# * <b>@user</b>    : ログイン中のユーザ情報(ログインしていない場合はnil)
#
class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authorize
  before_filter :load_session

  # 認証処理を実施する。
  # 認証が必要なページでは、事前にこの関数が呼び出される。
  # 認証済みでなければ、ログインページへ遷移する。
  def authorize
    if session[:is_login] != true
      session[:return_page] = request.url
      @error = 'ログインしてください。'
      render :template => 'top/index'
      return

    end

    # アカウントの有効性を確かめる。
    @user = User.find_by_login_id( session[:login_id] )
    if @user == nil
      session[:is_login] = false
      session[:return_page] = request.url
      @error = 'アカウントが存在しません。'
      render :template => 'top/index'
      return

    end

    if @user.account_status != User::STATUS_ENABLED
      session[:is_login] = false
      session[:return_page] = request.url
      @error = 'アカウントが無効です。'
      render :template => 'top/index'
      return

    end

  end

  # セッション情報をロードする。
  # ログイン済みの場合は、ユーザ情報を取得しておく。
  def load_session
    if session[:is_login] == true && @user == nil
      @user = User.find_by_login_id( session[:login_id] )
      if @user != nil
        if @user.account_status != User::STATUS_ENABLED
          @user = nil

        end

      end

    end

  end

end
