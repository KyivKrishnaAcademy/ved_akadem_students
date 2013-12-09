require 'spec_helper'

describe Person do

  after(:all) { Person.destroy_all }

  it { should have_db_column(:name              ).of_type(:string   ) }
  it { should have_db_column(:middle_name       ).of_type(:string   ) }
  it { should have_db_column(:surname           ).of_type(:string   ) }
  it { should have_db_column(:spiritual_name    ).of_type(:string   ) }
  it { should have_db_column(:telephone         ).of_type(:integer  ) }
  it { should have_db_column(:email             ).of_type(:string   ) }
  it { should have_db_column(:gender            ).of_type(:boolean  ) }
  it { should have_db_column(:birthday          ).of_type(:date     ) }
  it { should have_db_column(:emergency_contact ).of_type(:string   ) }
  it { should have_db_column(:photo             ).of_type(:text     ) }
  it { should have_db_column(:profile_fullness  ).of_type(:boolean  ) }
  it { should have_db_column(:edu_and_work      ).of_type(:text     ) }

  it { should have_one(:student_profile).dependent(:destroy) }

  it { should validate_presence_of(:name      ) }
  it { should validate_presence_of(:surname   ) }
  it { should validate_presence_of(:telephone ) }

  it { should     allow_value(  true, false   ).for(:gender) }
  it { should_not allow_value(  nil           ).for(:gender) }

  it { should ensure_length_of(:name            ).is_at_most(50) }
  it { should ensure_length_of(:surname         ).is_at_most(50) }
  it { should ensure_length_of(:middle_name     ).is_at_most(50) }
  it { should ensure_length_of(:spiritual_name  ).is_at_most(50) }

  it { should validate_numericality_of(:telephone ) }
  it { should validate_uniqueness_of(  :telephone ) }
  it { should ensure_inclusion_of(     :telephone )
        .in_range(100_000_000_000..999_999_999_999)
        .with_low_message(  /must be greater than/)
        .with_high_message( /must be less than/   ) }

  INVALID_ADDRESSES = %w[
    user@foo,com     user_at_foo.org
    example.user@foo.foo@bar_baz.com
    foo@bar+baz.com
  ]

  VALID_ADDRESSES   = %w[
    user@foo.COM A_US-ER@f.b.org
    frst.lst@foo.jp   a+b@baz.cn
  ]

  it do
    INVALID_ADDRESSES.each  do |invalid_address|
      should_not  allow_value(invalid_address).for(:email)
    end
  end

  it do
    VALID_ADDRESSES.each    do |valid_address|
      should      allow_value(  valid_address).for(:email)
    end
  end

  describe "email" do
    it "should be downcased" do
      VALID_ADDRESSES.each do |valid_address|
        create_person(email: valid_address).email.should == valid_address.downcase
      end
    end
  end

  describe "columns" do
    it "should be downcased and titelized" do
      name, surname, mname, spname = 'имЯ', 'фАмИлиЯ', 'ОтчествО', 'АдиДасаДаса ДаС'
      p = FactoryGirl.create(:person,
          name:           name    ,
          surname:        surname ,
          middle_name:    mname   ,
          spiritual_name: spname
        )
      p.name.should           ==  'Имя'
      p.surname.should        ==  'Фамилия'
      p.middle_name.should    ==  'Отчество'
      p.spiritual_name.should ==  'Адидасадаса Дас'
    end
  end

end
