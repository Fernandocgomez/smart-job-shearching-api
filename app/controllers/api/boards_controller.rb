class Api::BoardsController < ApplicationController
  def create
    board = Board.new(board_params)
    if board.valid?
      board.save
      render json: { "resp" => BoardSerializer.new(board) }, status: 201
    else
      render json: { "resp" => board.errors.messages }, status: 400
    end
  end

  def show
    board = Board.find_by_id(params[:id])
    if board
      render json: { "resp" => BoardSerializer.new(board) }, status: 200
    else
      render json: { "resp" => "board can't be found" }, status: 400
    end
  end

  def update
    board = Board.find_by_id(params[:id])
    if board
      board.update(board_params)
      if board.valid?
        render json: { "resp" => BoardSerializer.new(board) }, status: 200
      else
        render json: { "resp" => board.errors.messages }, status: 400
      end
    else
      render json: { "resp" => "board can't be found" }, status: 404
    end
  end

  def destroy
    board = Board.find_by_id(params[:id])
    if board
      board.destroy
      render json: { "resp" => "board has been deleted" }, status: 200
    else
      render json: { "resp" => "board can't be found" }, status: 404
    end
  end

  private

  def board_params
    params.permit(
      :name,
      :user_id
    )
  end
end
