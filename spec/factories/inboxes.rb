# coding: utf-8
# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :inbox do
    group
    article
    score { rand * 100 }
  end
end
