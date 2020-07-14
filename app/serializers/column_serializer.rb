class ColumnSerializer < ActiveModel::Serializer
  attributes :id, :name, :position, :board_id
end
