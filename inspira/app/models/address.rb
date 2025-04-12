# frozen_string_literal: true

class Address < ApplicationRecord
  belongs_to :client

  validates :street, :neighborhood, :city, :add_number, :uf, presence: true
  validates :cep, presence: true, format: { with: /\A\d{5}-\d{3}\z/, message: "deve ter o formato 00000-000" }
  validates :uf, length: { is: 2 }
end
