class Api::ColumnsController < ApplicationController
  def create
    column = Column.new(column_params)
    if column.valid?
      column.save
      render json: { "resp" => ColumnSerializer.new(column) }, status: 201
    else
      render json: { "resp" => column.errors.messages }, status: 400
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

  def column_params
    params.permit(
      :name,
      :position,
      :board_id
    )
  end
end
