require 'spec_helper'

describe Person do
  describe 'DB table' do
    it { should have_db_column(:name              ).of_type(:string   ) }
    it { should have_db_column(:middle_name       ).of_type(:string   ) }
    it { should have_db_column(:surname           ).of_type(:string   ) }
    it { should have_db_column(:spiritual_name    ).of_type(:string   ) }
    it { should have_db_column(:email             ).of_type(:string   ) }
    it { should have_db_column(:gender            ).of_type(:boolean  ) }
    it { should have_db_column(:birthday          ).of_type(:date     ) }
    it { should have_db_column(:emergency_contact ).of_type(:string   ) }
    it { should have_db_column(:passport          ).of_type(:string   ) }
    it { should have_db_column(:photo             ).of_type(:string   ) }
    it { should have_db_column(:profile_fullness  ).of_type(:boolean  ) }
    it { should have_db_column(:edu_and_work      ).of_type(:text     ) }
    it { should have_db_column(:encrypted_password).of_type(:string   ) }
    it { should have_db_column(:deleted           ).of_type(:boolean  ) }
  end

  describe 'association' do
    it { should have_one(:student_profile).dependent(:destroy) }
    it { should have_one(:teacher_profile).dependent(:destroy) }
    it { should have_one(:study_application).dependent(:destroy) }
    it { should have_and_belong_to_many(:roles) }
    it { should have_many(:telephones).dependent(:destroy) }
    it { should have_many(:answers).dependent(:destroy) }
  end

  describe 'validation' do
    context :password do
      it { should validate_confirmation_of(:password) }
      it { should ensure_length_of(:password).is_at_most(128) }
      it { should ensure_length_of(:password).is_at_least(6) }

      it 'should skip validation' do
        build(:person, password: '', password_confirmation: '', skip_password_validation: true).should be_valid
      end
    end

    context :gender do
      it { should     allow_value(true, false).for(:gender) }
      it { should_not allow_value(nil        ).for(:gender) }
    end

    context :email do
      it { should validate_uniqueness_of(:email) }

      INVALID_ADDRESSES = %w[
        user@foo,com     user_at_foo.org
        example.user@foo.foo@bar_baz.com
        foo@bar+baz.com
      ]

      VALID_ADDRESSES   = %w[
        user@foo.COM A_US-ER@f.b.org
        frst.lst@foo.jp   a+b@baz.cn
      ]

      it 'allows valid addresses' do
        INVALID_ADDRESSES.each  do |invalid_address|
          should_not  allow_value(invalid_address).for(:email)
        end
      end

      it 'disallows invalid addresses' do
        VALID_ADDRESSES.each    do |valid_address|
          should      allow_value(  valid_address).for(:email)
        end
      end

      it 'disallows empty value' do
        should_not allow_value('').for(:email)
      end
    end

    context 'name, surname, middle_name, spiritual_name' do
      it { should validate_presence_of(:name      ) }
      it { should validate_presence_of(:surname   ) }

      it { should ensure_length_of(:name            ).is_at_most(50) }
      it { should ensure_length_of(:surname         ).is_at_most(50) }
      it { should ensure_length_of(:middle_name     ).is_at_most(50) }
      it { should ensure_length_of(:spiritual_name  ).is_at_most(50) }
    end

    describe :photo do
      it 'less then 150x200 not valid' do
        build(:person, photo: File.open("#{Rails.root}/spec/fixtures/10x10.png")).should_not be_valid
      end

      it 'equals 150x200 valid' do
        build(:person, :with_photo).should be_valid
      end
    end
  end

  describe 'before save processing' do
    it 'downcases :email' do
      create(:person, {email: "A_US-ER@f.B.org"})
        .email.should == "a_us-er@f.b.org"
    end

    it 'downcases and titelizes :name, :surname, :middle_name, :spiritual_name' do
      name, surname, mname, spname = 'имЯ', 'фАмИлиЯ', 'ОтчествО', 'АдиДасаДаса ДаС'

      person = FactoryGirl.create(:person,
          name:           name    ,
          surname:        surname ,
          middle_name:    mname   ,
          spiritual_name: spname)

      person.name.should           ==  'Имя'
      person.surname.should        ==  'Фамилия'
      person.middle_name.should    ==  'Отчество'
      person.spiritual_name.should ==  'Адидасадаса Дас'
    end
  end

  describe '#crop_photo' do
    Given { @person = create :person }
    Given { @person.photo.should_receive(:recreate_versions!) }

    Then do
      @person.crop_photo(crop_x: 0, crop_y: 1, crop_h: 2, crop_w: 3).should be(true)
      @person.crop_x.should eq(0)
      @person.crop_y.should eq(1)
      @person.crop_h.should eq(2)
      @person.crop_w.should eq(3)
    end
  end
end
