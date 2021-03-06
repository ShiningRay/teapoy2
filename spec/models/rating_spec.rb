# == Schema Information
#
# Table name: ratings
#
#  id         :integer          not null, primary key
#  post_id    :integer          default(0), not null
#  user_id    :integer          default(0), not null
#  score      :integer          default(0), not null
#  created_at :datetime         not null
#
# Indexes
#
#  created_at                               (created_at)
#  index_ratings_on_article_id_and_user_id  (post_id,user_id) UNIQUE
#  index_ratings_on_score                   (score)
#

require 'rails_helper'

RSpec.describe Rating, type: :model do
  describe '#pos?' do
    let(:rating){ Rating.new score: 1 }
    it 'tests if score is positive' do
      expect(rating.pos?).to be true
    end
  end
  describe '#neg?' do
    let(:rating){ Rating.new score: -1 }
    it 'tests if score is negitive' do
      expect(rating.neg?).to be true
    end
  end

  describe '.make' do
    let(:user) { create :active_user }
    let(:post) { create(:topic).top_post }
    context 'when user has not rated yet' do
      it 'creates new rating' do
        expect{
          Rating.make user, post, 1
        }.to change(Rating, :count)
      end
    end
    context 'when user has already rated negative' do
      before do
        @rating = create :rating, user: user, post_id: post.id.to_s, score: -1
      end

      it 'does not create new rating' do
        expect{
          Rating.make user, post, 1
          }.not_to change(Rating, :count)
      end

      it 'change original rating score to positive' do
        Rating.make user, post, 1
        expect(@rating.reload.pos?).to be true
      end
    end

    context 'when user has already rated positive' do
      before do
        @rating = create :rating, user: user, post_id: post.id.to_s, score: 1
      end

      it 'does not create new rating' do
        expect{
          Rating.make user, post, -1
          }.not_to change(Rating, :count)
      end

      it 'change original rating score to negative' do
        Rating.make user, post, -1
        expect(@rating.reload.pos?).to be false
      end
    end
  end
end
