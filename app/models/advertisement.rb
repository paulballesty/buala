class Advertisement < ActiveRecord::Base
  extend FriendlyId

  attr_accessible :description, :title, :company, :company_id, :published, :category_1_id, :category_1, 
  	:category_2_id, :category_2, :advertisement_type, :advertisement_type_id, :is_paid,
    :working_turn, :working_turn_id, :start_date, :vacancies, :requirements, :short_description, 
    :recommendable

  belongs_to :company
  belongs_to :category_1, :class_name => 'Category'
  belongs_to :category_2, :class_name => 'Category'
  belongs_to :advertisement_type
  belongs_to :working_turn
  has_many :applications, order: 'created_at DESC'

  validates :title, :company, :category_1, :advertisement_type, :description, 
    :working_turn, :short_description, presence: true
  validates_length_of :title, :maximum => 45
  validate :different_categories
  validates :vacancies, numericality: { greater_than_or_equal_to: 0 }
  validates_length_of :short_description, :maximum => 250
  validate :if_is_recommendable_it_should_be_published

  has_many :postulations
  has_many :postulants, through: :postulations, source: :user

  scope :published, -> { where(published: true) }

  scope :published_order_by_creation, -> { where(published: true).order('created_at DESC')}

  friendly_id :title, use: :slugged

  def last_week_applications
    applications.where('created_at >= ?', DateTime.now - 1.weeks)
  end

  def last_week_postulations
    postulations.where('created_at >= ?', DateTime.now - 1.weeks)
  end

  def recommended
    Advertisement.published.where("id != ?", id).where(recommendable: true).sample(3)
  end

  def full_postulations
    Postulation.where(advertisement_id: self.id).join(:users)
  end

  private
  def different_categories
    if category_1 && category_2 && category_1 == category_2
      errors.add :category_2, 'Categories should be different'
    end
  end

  def if_is_recommendable_it_should_be_published
    if recommendable && !published
      errors.add :recommendable, 'To be a recommendable advertisement, first it should be published'
    end
  end

end
