# -*- coding: utf-8 -*-

# = 認証コントローラ
# Author:: Dolphin
# Date:: 2013.01.26
#
# 認証に関するコントローラである。
# 認証処理、ログイン、ログアウトなどを行う。
# 
class AuthController < ApplicationController
  skip_filter :authorize

  # ログイン受付。
  # パラメータで渡されたアカウント情報から、認証を行う。
  #
  # === パラメータ
  # [login_id] ログインID
  # [password] パスワード
  #
  def login
    @login_id = params[:login_id]
    @password = params[:password]

    if User.auth( @login_id, @password ) == false
      # 認証に失敗
      @error = '認証に失敗しました。'
      render :template => 'top/index'
      return

    end

    @user = User.find_by_login_id( @login_id )

    # 最終ログイン日時を更新する。
    @user.login

    # セッション情報を作成
    do_login( @login_id )

    # リターンページがあれば、そこへ移動
    if session[:return_page] != nil
      redirect_to session[:return_page]
      return

    end

    # マイページへ
    redirect_to :controller => '/my'

  end

  # ログアウト受付。
  # ログアウト処理を行い、トップページへ遷移する。
  def logout
    do_logout
    redirect_to :controller => '/top'

  end

  # ログイン処理の実施として。ログインセッションを作成する。
  #
  # === 引数
  # [login_id] ログインID
  #
  private 
  def do_login( login_id )
    session[:is_login] = true
    session[:login_id] = login_id

  end

  # ログアウト処理の実施として、ログインセッション情報をクリアする。
  private
  def do_logout
    session[:is_login] = false
    session[:login_id] = nil
    session[:return_page] = nil

  end

end
