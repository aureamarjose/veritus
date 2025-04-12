# frozen_string_literal: true

class Admin < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
    :registerable,
    :recoverable,
    :rememberable,
    :validatable,
    :timeoutable,
    :lockable,
    :trackable
    attr_accessor :updating_password

  validates :name, presence: true
  validates :password, presence: true, if: :password_being_updated?
  validates :password_confirmation , presence: true, if: :password_being_updated?

  private

  def password_being_updated?
    if updating_password
      return true
    else
      password.present? || password_confirmation.present?
    end
  end




end
