# -*- coding: utf-8 -*-

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# 初期管理アカウント
# 管理者アカウントが存在しない場合にのみ、管理者アカウントを生成する。
if User.find( :all, :conditions => { :account_type => User::TYPE_ADMIN } ).count <= 0
  admin_user = User.create_user(
    'admin', 'admin!', User::TYPE_ADMIN, '', 'Administrator', ''
  )
end

# カットパート
if CutPart.find( :all, :conditions => { :episode_id => nil } )[0].sort == nil
  # 旧データの場合
  CutPart.destroy( :all )
end
if CutPart.find( :all ).count <= 0 
  CutPart.create( :sort => 1, :name => 'アバンパート', :episode_id => nil )
  CutPart.create( :sort => 2, :name => 'OP', :episode_id => nil )
  CutPart.create( :sort => 3, :name => 'Aパート', :episode_id => nil )
  CutPart.create( :sort => 4, :name => 'アイキャッチ', :episode_id => nil )
  CutPart.create( :sort => 5, :name => 'Bパート', :episode_id => nil )
  CutPart.create( :sort => 6, :name => 'ED', :episode_id => nil )
  CutPart.create( :sort => 7, :name => '次回予告', :episode_id => nil )

end

