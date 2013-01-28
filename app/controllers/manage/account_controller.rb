# -*- coding: utf-8 -*-

# = Skeeter アカウント管理コントローラ
# Author:: Dolphin
# Date:: 2013.01.26
#
# Skeeter システム上のアカウント管理を行うページを扱う。
# 管理者のみアクセスすることができる。
#
class Manage::AccountController < ApplicationController
  before_filter :access_check

  # アクセス権限チェックを実施する。
  # アクセス権限がない場合、マイページへ遷移する。
  private
  def access_check
    unless @user.is_admin
      redirect_to :controller => '/my'
      return

    end
    
  end

  # Skeeter アカウント管理ページを表示する。
  # アカウントの一覧を表示し、各種操作のリンクを表示する。
  # また、アカウントの新規作成フォームも用意する。
  public
  def index
    @users = User.find( :all, :order => 'id' )
    
  end

  # アカウント情報の編集ページを表示する。
  # パラメータ mode が edit の場合、渡されたパラメータ情報を元に
  # アカウント情報を更新する。
  public
  def edit
    @edit_user = User.find( params[:id] )

    if params[:mode] == 'edit'
      if params[:commit] == '保存する'
        # アカウント情報を保存する。
        original_type = @edit_user.account_type
        @edit_user.login_id = params[:login_id]
        @edit_user.password = User.make_password_hash( params[:password] ) if params[:password] != ''
        @edit_user.mail_addr = params[:mail_addr]
        @edit_user.nick_name = params[:nick_name]
        @edit_user.real_name = params[:real_name]
        @edit_user.twitter = params[:twitter]
        @edit_user.pixiv = params[:pixiv]
        @edit_user.phone_number = params[:phone_number]
        @edit_user.account_type = params[:account_type]
        @edit_user.account_status = params[:account_status]

        # このアカウント以外に管理者アカウントがなく、無効化しようとしている場合ははじく。
        admins = User.find_by_enabled_admin()
        if admins.count <= 1 && original_type == User::TYPE_ADMIN
          if @edit_user.account_status == User::STATUS_DISABLED || ( ! @edit_user.is_admin? )
            @error = '唯一の管理者アカウントを無効化することはできません。'
            return
          end
        end

        if @edit_user.login_id == ''
          @error = '入力値に不備があります。'
          return

        end

        if @edit_user.save
          @info = 'アカウント情報を保存しました。'

        else
          @error = 'アカウント情報の保存に失敗しました。'

        end

      elsif params[:commit] == '削除する'
        User.destroy( params[:id] )
        redirect_to :action => 'index'
        return

      end

    end

  end

  # アカウントの新規作成を行う。
  # パラメータ mode が create の場合、渡されたパラメータ情報を元に
  # アカウント情報を作成する。
  public
  def new
    @new_user = User.new

    if params[:mode] == 'create'
      # アカウント情報を作成する。
      @new_user.login_id = params[:login_id]
      @new_user.password = User.make_password_hash( params[:password] )
      @new_user.mail_addr = params[:mail_addr]
      @new_user.nick_name = params[:nick_name]
      @new_user.real_name = params[:real_name]
      @new_user.twitter = params[:twitter]
      @new_user.pixiv = params[:pixiv]
      @new_user.phone_number = params[:phone_number]
      @new_user.account_type = params[:account_type]
      @new_user.account_status = params[:account_status]

      # 入力値チェック
      if @new_user.login_id == '' || params[:password] == ''
        @error = '入力値に不備があります。'
        return

      end

      if User.is_exists_login_id( @new_user.login_id ) == true
        @error = '既に存在するログインIDです。別のログインIDを入力してください。'
        return

      end

      if @new_user.save
        @info = 'ユーザを作成しました。'
        @new_user = User.new

      else
        @error = 'ユーザの作成に失敗しました。'

      end

    end

  end

end
