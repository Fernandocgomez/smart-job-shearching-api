class Api::ColumnsController < ApplicationController

  def create
    board = Board.find_by_id(column_params["board_id"])
    if is_user_authorized?(board)
      update_column_params = update_column_position(board, column_params)
      create_column(update_column_params)
    else
      render json: { "resp" => "you can not create a column that is not associated with one of yours boards without being an admin" }, status: 401
    end
  end

  def update
    column = Column.all.find_by_id(params[:id])
    if column
      column.update(column_params)
      if column.valid?
        render json: { "resp" => ColumnSerializer.new(column) }, status: 200
      else
        render json: { "resp" => column.errors.messages }, status: 400
      end
    else
      render json: { "resp" => "column can't be found" }, status: 404
    end
  end

  def destroy
    column = Column.all.find_by_id(params[:id])
    if column
      column.destroy
      render json: { "resp" => "column has been deleted" }, status: 200
    else
      render json: { "resp" => "column can't be found" }, status: 404
    end
  end

  private

  def is_user_authorized?(board)
    board.user_id == decoded_token[0]["user_id"]
  end

  def update_column_position(board, params)
    update_column_params = params
    if board.columns.size != 0
      update_column_params["position"] = board.columns.size
    end
    update_column_params
  end

  def create_column(params)
    column = Column.new(params)
    if column.valid?
      column.save
      render json: { "resp" => ColumnSerializer.new(column) }, status: 201
    else
      render json: { "resp" => column.errors.messages }, status: 400
    end
  end

  def column_params
    params.permit(
      :name,
      :position,
      :board_id
    )
  end
end
