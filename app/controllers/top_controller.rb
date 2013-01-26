# -*- coding: utf-8 -*-

# = トップページコントローラ
# Author:: Dolphin
# Date:: 2013.01.26
#
# トップレベルのページ遷移を制御するコントローラである。
# ログイン済みの場合は、マイページのトップへ移動する。
#
class TopController < ApplicationController
  skip_filter :authrize

  # コンストラクタ。
  # ページのタイトルを設定する。
  def initialize
    super
    @title = "Skeeter - アニメ進行管理ソリューション"
  end

  # トップページを表示する。
  def index
    # ログイン済みの場合、トップページではなく、マイページへ遷移する。
    if session[:is_login] == true
      redirect_to :controller => '/my'
      return

    end

  end

end
