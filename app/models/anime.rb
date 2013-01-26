# -*- coding: utf-8 -*-

# = アニメモデル
# Author:: Dolphin
# Date:: 2013.01.27
#
# == フィールド
# * *id*             : 通し番号
# * *title*          : タイトル
# * *owner_id*       : 責任者のユーザID
# * *description*    : 説明
# * *status*         : 状態(STATUS_***)
# * *created_at*     : 作成日時
# * *updated_at*     : 更新日時
#
class Anime < ActiveRecord::Base
  after_initialize :default_values
  attr_accessible :id, :title, :owner_id, :description, :created_at, :updated_at
  has_many :story
  belongs_to :owner, { :foreign_key => 'owner_id', :class_name => 'User' }

  # アニメの状態 無効
  STATUS_DISABLED = 0

  # アニメの状態 進行中
  STATUS_ENABLED = 1

  # アニメの状態 終了済
  STATUS_FINISHED = 2

  # 初期データ
  private
  def default_values
    self.description = '' if self.description == nil
  end

  # アニメ状態のハッシュ配列を返す。
  #
  # === 返り値
  # [Hash] { 名称 => 値 } の形で、アニメ状態一覧を返す。
  #
  def self.statuses
    return {
      '進行中'  => STATUS_ENABLED,
      '終了済'  => STATUS_FINISHED,
      '無効'    => STATUS_DISABLED
    }

  end

end
