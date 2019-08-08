require 'active_support/all'
require 'calculator/version'
# Calculator which calculates commission amount and net amount depending on input params.
# 1. Write Ruby gem - Calculator, which calculates commission amount and net
#     amount depending on input params
#     2. Input
#      - amount *required
#      - commission_amount *optional
#      - commission_percent *optional
#      - commission_entity(user, product) *optional
#      Output -
#     [net_amount, commission_amount]
#     3. If there's no commission - then it's set by default.
#     4. Possibility to change commission depending on:
#      - product type
#      - user
#      - product price(amount)
#     5. Code should be covered with unit tests.
#     6. Possibility to calculate commission with two digits after decimal point precision.
#     Calculator.call(amount: 100, commission_amount: 1.0, commission_percent: 20)
#     commission_total = 100.0 * 0.2 + 1.0 = 21.0
#     net_amount = 100.0 - 21.0 = 79.0
#      => [79.0, 21.0]
module Calculator
  VALID_COMMISSION_ENTITIES     = %w[user product].freeze
  AMOUNTS_COMMISSION_CORRECTION = {(0..100_000)                    => 0.0,
                                   (100_001..300_000)              => -0.1,
                                   (300_001..500_000)              => -0.2,
                                   (500_001..BigDecimal::INFINITY) => -0.3}.freeze

  class << self
    def call(amount:,
             commission_amount: nil,
             commission_percent: nil,
             commission_entity: nil)
      validate_call_args(amount, commission_amount, commission_percent, commission_entity)
      amount             = amount.to_d
      commission_amount  = (commission_amount || 1.0).to_d
      commission_percent = ((commission_percent || 20.0) / 100.0).to_d
      if commission_entity
        get_amounts_entity(amount, commission_amount, commission_percent, commission_entity)
      else
        get_amounts_no_entity(amount, commission_amount, commission_percent)
      end
    end

    private

    def validate_call_args(amount, commission_amount, commission_percent, commission_entity)
      unless valid_amount? amount
        raise ArgumentError, 'Amount must be zero or positive number!'
      end
      unless valid_commission_amount? commission_amount
        raise ArgumentError,
              'Commission amount must be zero or positive number!'
      end
      unless valid_commission_percent? commission_percent
        raise ArgumentError,
              'Commission percent must be a zero or positive number and not exceed 100%!'
      end
      unless valid_commission_entity? commission_entity
        raise ArgumentError,
              'Commission Entity should be User or Product!'
      end
    end

    def valid_amount?(amount)
      amount.is_a?(Numeric) && amount >= 0
    end

    def valid_commission_amount?(commission_amount)
      commission_amount.nil? || (commission_amount.is_a?(Numeric) &&
          commission_amount >= 0)
    end

    def valid_commission_percent?(commission_percent)
      commission_percent.nil? || (commission_percent.is_a?(Numeric) &&
          commission_percent <= 100 && commission_percent >= 0)
    end

    # TODO: need to verify logic here
    def valid_commission_entity?(commission_entity)
      commission_entity.nil? ||
          valid_commission_entity_class?(commission_entity)
    end

    def valid_commission_entity_class?(commission_entity)
      VALID_COMMISSION_ENTITIES.any? do |v|
        commission_entity.class.to_s.downcase == v
      end
    end

    # TODO: need to verify logic here
    def get_amounts_entity(amount, commission_amount, commission_percent, commission_entity)
      if class_name_match?(commission_entity, 'User')
        commission_amount  = user_commission_amount commission_entity
        commission_percent = user_commission_percent(commission_entity)
      elsif class_name_match?(commission_entity, 'Product')
        commission_percent += product_extra_commission(commission_entity)
      end
      get_amounts_no_entity amount, commission_amount, commission_percent
    end

    def product_extra_commission commission_entity
      (commission_entity&.product_type&.extra_commission_rate) || 0
    end

    def user_commission_percent commission_entity
      ((commission_entity&.commission_percent || 0) / 100.0).to_d
    end

    def user_commission_amount user
      (user&.commission_fixed_fee || 0).to_d.round(2)
    end

    def class_name_match?(commission_entity, class_name)
      commission_entity.class.to_s == class_name
    end

    def get_amounts_no_entity(amount, commission_amount, commission_percent)
      corrected_commission_percent = correct_percent_to_amount amount, commission_percent
      commission_percent           = corrected_commission_percent < 0 ? 0 : corrected_commission_percent
      commission_total             = ((amount * commission_percent) + commission_amount).round(2)
      net_amount                   = (amount - commission_total).round(2)
      raise ArgumentError, 'Total commission should not exceed amount!' if net_amount < 0
      [net_amount, commission_total]
    end

    def correct_percent_to_amount(amount, commission_percent)
      AMOUNTS_COMMISSION_CORRECTION.each do |range, correction|
        return (commission_percent += correction) if amount.in? range
      end
      amount
    end
  end
end
