class Api::BoardsController < ApplicationController
  def create
    if check_user_privileges(params)
      create_board
    else
      render json: { "resp" => "you can not create board that are not associated with your user without being an admin" }, status: 401
    end
  end

  def show
    board = Board.find_by_id(params[:id])
    if board
      if check_user_privileges(board)
        render json: { "resp" => BoardSerializer.new(board) }, status: 200
      else
        render json: { "resp" => "you can not access to other users' boards without being an admin" }, status: 401
      end
    else
      render json: { "resp" => "board can't be found" }, status: 404
    end
  end

  def update
    board = Board.find_by_id(params[:id])
    if board
      if check_user_privileges(board)
        board.update(board_params)
        if board.valid?
          render json: { "resp" => BoardSerializer.new(board) }, status: 200
        else
          render json: { "resp" => board.errors.messages }, status: 400
        end
      else
        render json: { "resp" => "you can not edit other users' boards without being an admin" }, status: 401
      end
    else
      render json: { "resp" => "board can't be found" }, status: 404
    end
  end

  def destroy
    board = Board.find_by_id(params[:id])
    if board
      if check_user_privileges(board)
        board.destroy
        render json: { "resp" => "board has been deleted" }, status: 200
      else
        render json: { "resp" => "you can not delete other users' boards without being an admin" }, status: 401
      end
    else
      render json: { "resp" => "board can't be found" }, status: 404
    end
  end

  private

  def create_board
    board = Board.new(board_params)
    if board.valid?
      board.save
      render json: { "resp" => BoardSerializer.new(board) }, status: 201
    else
      render json: { "resp" => board.errors.messages }, status: 400
    end
  end

  def check_user_privileges(object)
    object[:user_id].to_i == decoded_token[0]["user_id"]
  end

  def board_params
    params.permit(
      :name,
      :user_id
    )
  end
end
