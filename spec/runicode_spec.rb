require 'spec_helper'

describe Runicode do
  def bytes_to_string(bytes)
    bytes.pack('C*').force_encoding('UTF-8')
  end

  # lrm = Left to Right Mark
  let(:lrm_bytes) { [0xE2, 0x80, 0x8E] }
  let(:nbsp_bytes) { [0xC2, 0xA0] }
  let(:lrm_string) { bytes_to_string(lrm_bytes) }
  let(:nbsp_string) { bytes_to_string(nbsp_bytes) }
  let(:foo) { 'foo' }

  describe '#strip' do
    context 'without extra whitespace' do
      context 'leading LRM string' do
        let(:my_string) { lrm_string + foo }
        subject { Runicode.strip(my_string) }
        it { is_expected.to eq(foo) }
      end

      context 'trailing LRM string' do
        let(:my_string) { foo + lrm_string }
        subject { Runicode.strip(my_string) }
        it { is_expected.to eq(foo) }
      end

      context 'leading and trailing LRM marks' do
        let(:my_string) { lrm_string + foo + lrm_string }
        subject { Runicode.strip(my_string) }
        it { is_expected.to eq(foo) }
      end

      context 'interspersed LRM marks' do
        let(:mid_string) { foo.insert(1, lrm_string) }
        let(:my_string) { lrm_string + 'f' + lrm_string + 'oo' + lrm_string }
        subject { Runicode.strip(my_string) }
        it { is_expected.to eq(mid_string) }
      end

      context 'leading NBSP string' do
        let(:my_string) { nbsp_string + foo }
        subject { Runicode.strip(my_string) }
        it { is_expected.to eq(foo) }
      end

      context 'trailing NBSP string' do
        let(:my_string) { foo + nbsp_string }
        subject { Runicode.strip(my_string) }
        it { is_expected.to eq(foo) }
      end

      context 'leading and trailing NBSP marks' do
        let(:my_string) { nbsp_string + foo + nbsp_string }
        subject { Runicode.strip(my_string) }
        it { is_expected.to eq(foo) }
      end

      context 'interspersed NBSP marks' do
        let(:mid_string) { foo.insert(1, nbsp_string) }
        let(:my_string) { nbsp_string + mid_string + nbsp_string }
        subject { Runicode.strip(my_string) }
        it { is_expected.to eq(mid_string) }
      end
    end

    context 'with extra whitespace' do
      let(:spacey_foo) { "  \tfoo \t\r\n\t   " }

      context 'leading LRM string' do
        let(:my_string) { lrm_string + spacey_foo }
        subject { Runicode.strip(my_string) }
        it { is_expected.to eq(foo) }
      end

      context 'trailing LRM string' do
        let(:my_string) { spacey_foo + lrm_string }
        subject { Runicode.strip(my_string) }
        it { is_expected.to eq(foo) }
      end

      context 'leading and trailing LRM marks' do
        let(:my_string) { lrm_string + spacey_foo + lrm_string }
        subject { Runicode.strip(my_string) }
        it { is_expected.to eq(foo) }
      end

      context 'interspersed LRM marks' do
        let(:mid_string) { "Hello \t " + lrm_string + "\r\n World" }
        let(:my_string) { " \t" + lrm_string + "\r\n \t \r" + mid_string + lrm_string + " \t  \r  \t \n"}
        subject { Runicode.strip(my_string) }
        it { is_expected.to eq(mid_string) }
      end

      context 'leading NBSP string' do
        let(:my_string) { nbsp_string + spacey_foo }
        subject { Runicode.strip(my_string) }
        it { is_expected.to eq(foo) }
      end

      context 'trailing NBSP string' do
        let(:my_string) { spacey_foo + nbsp_string }
        subject { Runicode.strip(my_string) }
        it { is_expected.to eq(foo) }
      end

      context 'leading and trailing NBSP marks' do
        let(:my_string) { nbsp_string + spacey_foo + nbsp_string }
        subject { Runicode.strip(my_string) }
        it { is_expected.to eq(foo) }
      end

      context 'interspersed NBSP marks' do
        let(:mid_string) { "Hello \t " + nbsp_string + "\r\n World" }
        let(:my_string) { " \t" + nbsp_string + "\r\n \t \r" + mid_string + nbsp_string + " \t  \r  \t \n"}
        subject { Runicode.strip(my_string) }
        it { is_expected.to eq(mid_string) }
      end
    end
  end
end