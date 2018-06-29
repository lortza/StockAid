class CountSheet < ApplicationRecord
  belongs_to :inventory_reconciliation
  belongs_to :bin, optional: true
  has_many :count_sheet_details
  has_many :items, -> { order(:description) }, through: :count_sheet_details
end