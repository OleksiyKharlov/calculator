RSpec.describe Calculator do
  context "When testing the Calculator class" do
    unless defined? User
      class User
        attr_reader :commission_percent, :commission_fixed_fee

        def initialize(commission_percent: 0,
                       commission_fixed_fee: 0)
          @commission_percent   = commission_percent
          @commission_fixed_fee = commission_fixed_fee
        end
      end
    end

    unless defined? Product
      class Product
        attr_reader :product_type

        def initialize(product_type:)
          raise ArgumentError, "product_type must be ProductType instance" unless product_type.is_a? ProductType
          @product_type = product_type
        end
      end
    end

    unless defined? ProductType
      class ProductType
        attr_reader :extra_commission_rate

        def initialize(extra_commission:)
          @extra_commission_rate = extra_commission
        end
      end

    end

    class WrongEntity
    end

    it "has a version number" do
      expect(Calculator::VERSION).not_to be nil
    end


    context 'The call() method should return array of two elements when passed valid arguments:' do

      it 'calculates commission amount without entity and with all other args provided' do
        call_args       = {amount:             120,
                           commission_amount:  1.0,
                           commission_percent: 20}
        expected_result = [95.0.to_d.round(2),
                           25.0.to_d.round(2)]
        expect(Calculator.call(call_args)).to eq(expected_result)
      end

      it 'calculates commission amount without entity and just amount provided' do
        call_args       = {amount: 100}
        expected_result = [79.0.to_d.round(2),
                           21.0.to_d.round(2)]
        expect(Calculator.call(call_args)).to eq(expected_result)
      end

      it 'calculates commission amount with User entity and all other args provided' do
        user            = User.new(commission_percent:   20,
                                   commission_fixed_fee: 1)
        call_args       = {amount:             120,
                           commission_amount:  1.0,
                           commission_percent: 20,
                           commission_entity:  user}
        expected_result = [95.0.to_d.round(2),
                           25.0.to_d.round(2)]
        expect(Calculator.call(call_args)).to eq(expected_result)
      end

      it 'calculates commission amount with Product entity and all other args provided' do
        class Product
        end
        product         = Product.new(product_type:
                                          ProductType.new(extra_commission:
                                                              0.17))
        call_args       = {amount:             120,
                           commission_amount:  1.0,
                           commission_percent: 10,
                           commission_entity:  product}
        expected_result = [86.60.to_d.round(2),
                           33.4.to_d.round(2)]
        expect(Calculator.call(call_args)).to eq(expected_result)
      end

      it 'calculates commission amount with just entity and amount provided' do
        user            = User.new(commission_percent:   20,
                                   commission_fixed_fee: 1)
        call_args       = {amount:            100,
                           commission_entity: user}
        expected_result = [79.0.to_d.round(2),
                           21.0.to_d.round(2)]
        expect(Calculator.call(call_args)).to eq(expected_result)
      end

      it 'calculates commission amount with just Product entity and amount provided' do
        user            = Product.new(product_type: ProductType.new(extra_commission: 0.17))
        call_args       = {amount:            120,
                           commission_entity: user}
        expected_result = [74.60.to_d.round(2),
                           45.40.to_d.round(2)]
        expect(Calculator.call(call_args)).to eq(expected_result)
      end

      it 'calculates commission amount with just Product entity and huge amount provided' do
        user            = Product.new(product_type: ProductType.new(extra_commission: 0.17))
        call_args       = {amount:            1_200_000,
                           commission_entity: user}
        expected_result = [1_115_999.0.to_d.round(2),
                           84_001.0.to_d.round(2)]
        expect(Calculator.call(call_args)).to eq(expected_result)
      end

    end

    context 'The call() method should raise ArgumentError when passed invalid arguments:' do

      it 'raises ArgumentError when called without params' do
        expect do
          Calculator.call()
        end.to raise_error(ArgumentError, 'missing keyword: amount')
      end

      it 'raises ArgumentError when called with invalid amount' do
        expect do
          Calculator.call(amount: '')
        end.to raise_error(ArgumentError, 'Amount must be zero or positive number!')
      end

      it 'raises ArgumentError when called with invalid type commission_amount' do
        expect do
          Calculator.call(amount: 100, commission_amount: '')
        end.to raise_error(ArgumentError, 'Commission amount must be zero or positive number!')
      end

      it 'raises ArgumentError when called with invalid negative commission_amount' do
        expect do
          Calculator.call(amount: 100, commission_amount: -10)
        end.to raise_error(ArgumentError, 'Commission amount must be zero or positive number!')
      end

      it 'raises ArgumentError when called with invalid type commission_percent' do
        expect do
          Calculator.call(amount: 100, commission_percent: '')
        end.to raise_error(ArgumentError, 'Commission percent must be a zero or positive number and not exceed 100%!')
      end

      it 'raises ArgumentError when called with invalid negative commission_percent' do
        expect do
          Calculator.call(amount: 100, commission_percent: -1)
        end
            .to raise_error(ArgumentError, 'Commission percent must be a zero or positive number and not exceed 100%!')
      end

      it 'raises ArgumentError when called with invalid more than 100 commission_percent' do
        expect do
          Calculator.call(amount: 100, commission_percent: 102)
        end
            .to raise_error(ArgumentError,
                            'Commission percent must be a zero or positive number and not exceed 100%!')
      end

      it 'raises ArgumentError when called with invalid type commission_entity' do
        expect do
          Calculator.call(amount: 100, commission_entity: '')
        end.to raise_error(ArgumentError, 'Commission Entity should be User or Product!')
      end

      it 'raises ArgumentError when called with invalid type custom class commission_entity' do
        bad_entity = WrongEntity.new
        expect do
          Calculator.call(amount: 100, commission_entity: bad_entity)
        end.to raise_error(ArgumentError, 'Commission Entity should be User or Product!')
      end

    end

  end
end
