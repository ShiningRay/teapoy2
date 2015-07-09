# coding: utf-8
# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :attachment do
    file { File.open(Rails.root.join('spec/fixtures/2345.jpg'), 'rb') }

  end
end
