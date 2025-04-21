# frozen_string_literal: true

module ApplicationHelper
  def find_cash_flow_data(cash_flow, name)
    flow = cash_flow.find { |f| f[:name] == name }
    flow ? flow[:data].sort_by { |date, _| Date.strptime(date, I18n.t('time.formats.date')) } : []
  end
end
