class Api::ColumnsController < ApplicationController

  def create
    board = Board.find_by_id(column_params["board_id"])
    if is_user_authorized?(board)
      updated_column_params = assign_column_position(board, column_params)
      create_column(updated_column_params)
    else
      render json: { "resp" => "you can not create a column that is not associated with one of yours boards without being an admin" }, status: 401
    end
  end

  def update
    column = Column.find_by_id(params[:id])
    if column
      board = Board.find_by_id(column["board_id"])
      if is_user_authorized?(board)
        if has_same_position?(column, column_params) && !column_params["name"]
          render json: { "resp" => "column has the same position value" }, status: 400
        else
          if column_params["position"] && !column_params["name"]
            update_position(column, column_params)
          else
            update_column(column, column_params)
          end
        end
      else
        render json: { "resp" => "you can not update a column that is not associated with one of yours boards without being an admin" }, status: 401
      end
    else
      render json: { "resp" => "column can't be found" }, status: 404
    end
  end

  def destroy
    column = Column.find_by_id(params[:id])
    if column
      board = Board.find_by_id(column["board_id"])
      if is_user_authorized?(board)
        update_positions_before_delete(board, column)
        delete_column(column)
      else
        render json: { "resp" => "you can not delete a column that is not associated with one of yours boards without being an admin" }, status: 401
      end
    else
      render json: { "resp" => "column can't be found" }, status: 404
    end
  end

  private

  def is_user_authorized?(board)
    board.user_id == decoded_token[0]["user_id"]
  end

  def assign_column_position(board, params)
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

  def has_same_position?(column, params)
    column.position.to_s == params["position"]
  end

  def update_position(column, params)
    current_postion = column.position
    new_position = params["position"].to_i
    columns_associated_with_board = column.board.columns
    if current_postion > new_position
      columns_associated_with_board.each do |record|
        if record.position.between?(new_position, current_postion)
          if record.id == column.id
            record.update(position: new_position)
          else
            record.update(position: record.position + 1)
          end
        end
      end
    else
      columns_associated_with_board.each do |record| 
        if record.position.between?(current_postion, new_position)
          if record.id == column.id
            record.update(position: new_position)
          else
            record.update(position: record.position - 1)
          end
        end
      end
    end
    updated_column = Column.find_by_id(column.id)
    render json: {"resp" => ColumnSerializer.new(updated_column)}, status: 200
  end

  def update_column(column, params)
    column.update(params)
    if column.valid?
      render json: { "resp" => ColumnSerializer.new(column) }, status: 200
    else
      render json: { "resp" => column.errors.messages }, status: 400
    end
  end

  def update_positions_before_delete(board, column)
    all_columns = board.columns
    all_columns.each do |record|
      if record.position > column.position
        record.update({"position" => record.position - 1})
      end
    end
  end

  def delete_column(column)
    column.destroy
    render json: { "resp" => "column has been deleted" }, status: 200
  end

  def column_params
    params.permit(
      :name,
      :position,
      :board_id
    )
  end
end
