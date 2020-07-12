class BoardsController < ApplicationController

  def create
    board = Board.new(board_params)
    if board.valid? 
      board.save
      render json: {'resp' => BoardSerializer.new(board)}, status: 201 
    else
      render json: {'resp' => board.errors.messages}, status: 400
    end
  end

  def show
  end

  def update
  end

  def destroy
  end

  private

  def board_params
    params.permit(
      :name, 
      :user_id
    )
  end

end
