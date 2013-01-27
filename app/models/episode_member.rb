# -*- coding: utf-8 -*-

# = エピソード関係者モデル
# Author:: Dolphin
# Date:: 2013.01.28
#
# == フィールド
# * *id*             : 通し番号
# * *user_id*        : ユーザID
# * *episode_id*     : エピソードID
# * *role*           : 役割(ROLE_***)
class EpisodeMember < ActiveRecord::Base
  attr_accessible :user_id, :episode_id, :role
  belongs_to :user, :foreign_key => 'user_id'
  belongs_to :episode, :foreign_key => 'episode_id'

  # 役割 一般
  ROLE_GENERAL = 0

  # 役割 進行管理
  ROLE_MANAGER = 1

  # 役割のハッシュ配列を返す。
  #
  # === 返り値
  # [Hash] { 名称 => 値 } の形で、役割を返す。
  #
  def self.roles
    return {
      '一般'       => ROLE_GENERAL,
      '進行管理'   => ROLE_MANAGER
    }

  end


end
