# -*- coding: utf-8 -*-

# = アニメコントローラ
# Author:: Dolphin
# Date:: 2013.01.27
#
class AnimeController < ApplicationController

  def edit
    if params[:id] == nil
      redirect_to :controller => '/my'
      return
      
    end

    if session['info'] != nil
      @info = session[:info]
      session['info'] = nil
      
    end

    @anime = Anime.find_by_id( params[:id] )

    # アクセス権限チェック
    if check_edit_permission( @anime ) == false
      redirect_to :controller => '/my'
      return

    end

    if params[:mode] == 'edit'
      if params[:commit] == '保存する'
        # アカウント情報を保存する。
        @anime.title = params[:title]
        @anime.owner_id = params[:owner_id] if @user.is_admin
        @anime.total_episode_number = params[:total_episode_number]
        @anime.status = params[:status]
        @anime.description = params[:description]

        if @anime.title == ''
          @error = '入力値に不備があります。'
          return

        end

        if @anime.save
          @info = 'アニメ情報を保存しました。'

        else
          @error = 'アニメ情報の保存に失敗しました。'

        end
      end
    elsif params[:mode] == 'edit_episode'
      @episode = Episode.find_by_id( params[:episode_id] )
      if params[:commit] == '保存する'
        unless @episode.nil?
          @episode.title = params[:title]
          @episode.director_id = params[:director_id]
          @episode.episode_number = params[:episode_number]
          @episode.description = params[:description]
          @episode.status = params[:status]
          @episode.deadline = params[:deadline]

          if @episode.title == ''
            @error = '入力値に不備があります。'
            return

          end

          if @episode.save
            @info = 'エピソード情報を保存しました。'

          else
            @error = 'エピソード情報の保存に失敗しました。'

          end

        end

      elsif params[:commit] == '削除する'
        Episode.destroy( params[:episode_id] )
        session['info'] = 'アニメ「' + @episode.title + '」を削除しました。'
        redirect_to :action => 'edit', :id => params[:id]
        return

      end

    end

    if params[:episode_id] == '' || params[:episode_id] == nil
      params[:episode_id] = @anime.episode.last.id if @anime.episode.count > 0
    else
      params[:mode] = 'edit_episode'
    end
    @episode = Episode.find_by_id( params[:episode_id] ) if params[:episode_id] != nil

  end

  # アニメにストーリーを追加する。
  def ajax_add_episode
    return if params[:episode_name] == '' || params[:episode_name] == nil
    @anime = Anime.find_by_id( params[:id] )
    return if @anime.nil?

    # アクセス権限チェック
    return unless check_edit_permission( @anime )

    @episode = Episode.add( @anime, params[:episode_name] )

  end

  # カットパートを追加する。
  def ajax_add_cut_part
    return if params[:name] == '' || params[:name] == nil
    @anime = Anime.find_by_id( params[:id] )
    return if @anime.nil?

    # アクセス権限チェック
    return unless check_edit_permission( @anime )

    @cut_part = CutPart.add( params[:episode_id], params[:name] )

  end

  # カットパートを削除する。
  def ajax_remove_cut_part
    return if params[:cut_part_id].nil?
    @cut_part = CutPart.find_by_id( params[:cut_part_id] )
    return if @cut_part.nil?

    # アクセス権限チェック
    return unless check_edit_permission( @cut_part.episode.anime )
    
    @cut_part.remove

  end

  # カットパートを上に移動する。
  def ajax_up_cut_part
    return if params[:cut_part_id].nil?
    @cut_part = CutPart.find_by_id( params[:cut_part_id] )
    return if @cut_part.nil?

    # アクセス権限チェック
    return unless check_edit_permission( @cut_part.episode.anime )
    
    @sort_from = @cut_part.sort
    @cut_part.move_up
    @sort_to = @cut_part.sort

  end
  
  # カットパートを下に移動する。
  def ajax_down_cut_part
    return if params[:cut_part_id].nil?
    @cut_part = CutPart.find_by_id( params[:cut_part_id] )
    return if @cut_part.nil?

    # アクセス権限チェック
    return unless check_edit_permission( @cut_part.episode.anime )
    
    @sort_from = @cut_part.sort
    @cut_part.move_down
    @sort_to = @cut_part.sort

  end

  # メンバーを追加する。
  public
  def ajax_add_episode_member
    @episode = Episode.find_by_id( params[:episode_id] )
    return if @episode.nil?

    # アクセス権限チェック
    return unless check_edit_permission( @episode.anime )

    @member = EpisodeMember.add_member( @episode, params[:user_id], params[:role] )
    
  end

  # メンバーを削除する。
  public
  def ajax_remove_episode_member
    @episode = Episode.find_by_id( params[:episode_id] )
    return if @episode.nil?
    @result = false

    # アクセス権限チェック
    return unless check_edit_permission( @episode.anime )

    @member = nil
    @episode.member.each do |member|
      if member.user.id == params[:user_id].to_i 
        @member = member
        break
      end
    end
    return if @member == nil
    @result = EpisodeMember.remove_member( @episode, params[:user_id] )
    
  end

  # 編集権限を確認する。
  # 作品責任者 or システム管理者のみ編集を許可。
  #
  # === 返り値
  # [true] 編集権限OK
  # [false] 編集権限がない
  #
  private
  def check_edit_permission( anime )
    return false if anime.nil?
    return false if anime.owner.id != @user.id && ( ! @user.is_admin? )
    return true
  end

end
