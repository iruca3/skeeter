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

  # 役割名を返す。
  public
  def role_name
    EpisodeMember.roles.each do |name, val|
      return name if val == self.role
    end
    return '不明'

  end

  # メンバーを追加する。
  #
  # === 返り値
  # [EpisodeMember] 追加に成功
  # [nil] 追加に失敗
  #
  public
  def self.add_member( episode, user_id, role )
    episode_id = episode.id
    user_id = user_id.to_i
    return nil if episode_id <= 0
    return nil if user_id <= 0
   
    return nil if episode.contain_member( user_id )
    
    member = EpisodeMember.new(
      :episode_id => episode.id,
      :user_id => user_id,
      :role => role
    )
    if ! member.save
      return nil
    end
    return member

  end

  # メンバーを削除する。
  #
  # === 返り値
  # [true] 削除に成功
  # [false] 削除に失敗
  #
  public
  def self.remove_member( episode, user_id )
    episode_id = episode.id
    user_id = user_id.to_i
    return false if episode_id <= 0
    return false if user_id <= 0
   
    return false if ! episode.contain_member( user_id )

    EpisodeMember.delete_all( :user_id => user_id, :episode_id => episode.id )
    return true
    
  end

end
