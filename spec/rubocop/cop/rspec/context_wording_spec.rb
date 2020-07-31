# frozen_string_literal: true

RSpec.describe RuboCop::Cop::RSpec::ContextWording, :config do
  let(:cop_config) { { 'Prefixes' => %w[when with], 'Patterns' => nil } }

  context 'with Prefix settings' do
    it 'skips describe blocks' do
      expect_no_offenses(<<-RUBY)
        describe 'the display name not present' do
        end
      RUBY
    end

    it 'finds context without `when` at the beginning' do
      expect_offense(<<-RUBY)
        context 'the display name not present' do
                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Write context description like '^when\\b', or '^with\\b'.
        end
      RUBY
    end

    it 'finds shared_context without `when` at the beginning' do
      expect_offense(<<-RUBY)
        shared_context 'the display name not present' do
                       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Write context description like '^when\\b', or '^with\\b'.
        end
      RUBY
    end

    it "skips descriptions beginning with 'when'" do
      expect_no_offenses(<<-RUBY)
        context 'when the display name is not present' do
        end
      RUBY
    end

    it "skips descriptions beginning with 'when,'" do
      expect_no_offenses(<<-RUBY)
        context 'when, for some inexplicable reason, you inject a subordinate clause' do
        end
      RUBY
    end

    it 'finds context without separate `when` at the beginning' do
      expect_offense(<<-RUBY)
        context 'whenever you do' do
                ^^^^^^^^^^^^^^^^^ Write context description like '^when\\b', or '^with\\b'.
        end
      RUBY
    end
  end

  context 'with Pattern settings' do
    let(:cop_config) { { 'Prefixes' => nil, 'Patterns' => %w[時$ ^もし.*ならば$] } }

    it 'skips describe blocks' do
      expect_no_offenses(<<-RUBY)
        describe 'the display name not present' do
        end
      RUBY
    end

    it 'finds context without `時` at the ending' do
      expect_offense(<<-RUBY)
        context 'the display name not present' do
                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Write context description like '時$', or '^もし.*ならば$'.
        end
      RUBY
    end

    it 'finds shared_context without `時` at the ending' do
      expect_offense(<<-RUBY)
        shared_context 'the display name not present' do
                       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Write context description like '時$', or '^もし.*ならば$'.
        end
      RUBY
    end

    it "skips descriptions ending with '時'" do
      expect_no_offenses(<<-RUBY)
        context 'display nameが存在しない時' do
        end
      RUBY
    end

    it "skips descriptions matching with '^もし.*ならば$'" do
      expect_no_offenses(<<-RUBY)
        context 'もしdisplay nameが存在しないならば' do
        end
      RUBY
    end
  end

  context 'with metadata hash' do
    it 'finds context without separate `when` at the beginning' do
      expect_offense(<<-RUBY)
        context 'whenever you do', legend: true do
                ^^^^^^^^^^^^^^^^^ Write context description like '^when\\b', or '^with\\b'.
        end
      RUBY
    end
  end

  context 'with symbol metadata' do
    it 'finds context without separate `when` at the beginning' do
      expect_offense(<<-RUBY)
        context 'whenever you do', :legend do
                ^^^^^^^^^^^^^^^^^ Write context description like '^when\\b', or '^with\\b'.
        end
      RUBY
    end
  end

  context 'with mixed metadata' do
    it 'finds context without separate `when` at the beginning' do
      puts cop_config
      expect_offense(<<-RUBY)
        context 'whenever you do', :legend, myth: true do
                ^^^^^^^^^^^^^^^^^ Write context description like '^when\\b', or '^with\\b'.
        end
      RUBY
    end
  end

  context 'when configured' do
    let(:cop_config) { { 'Prefixes' => %w[if], 'Patterns' => nil } }

    it 'finds context without allowed prefixes at the beginning' do
      expect_offense(<<-RUBY)
        context 'when display name is present' do
                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Write context description like '^if\\b'.
        end
      RUBY
    end

    it 'skips descriptions with allowed prefixes at the beginning' do
      expect_no_offenses(<<-RUBY)
        context 'if display name is present' do
        end
      RUBY
    end
  end
end
