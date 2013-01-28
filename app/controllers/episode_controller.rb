# -*- coding: utf-8 -*-

# = エピソードコントローラ
# Author:: Dolphin
# Date:: 2013.01.29
#
class EpisodeController < ApplicationController

  def index
    if params[:id].blank?
      redirect_to :controller => '/my', :id => 1
      return

    end

    @episode = Episode.find_by_id( params[:id] )
    if @episode.nil?
      redirect_to :controller => '/my', :id => 1
      return

    end

    # 権限チェック
    unless @episode.contain_member( @user.id )
      redirect_to :controller => '/my', :id => 1 unless @user.is_admin?
      return

    end
      
  end

end
