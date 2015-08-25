require_relative '../spec_helper'

describe 'HParser' do
  let(:helper) { ParseHelper.new }
  let(:helper_with_options) { ParseHelper.new(options) }

  describe '#initialize' do
    context 'when no options are given' do
      it 'assigns @marker' do
        expect(helper.instance_variable_get(:@page_names)).to eq([])
        expect(helper.instance_variable_get(:@base_uri)).to eq('/')
        expect(helper.instance_variable_get(:@pagelist_suffix)).to eq('/')
      end
    end

    context 'when options are given' do
      let(:options) {
        {
          page_names: %w(page1, page2),
          base_uri: 'sample_base_uri',
          pagelist_suffix: 'sample_pagelist_suffix'
        }
      }
      it 'assigns @marker' do
        expect(helper_with_options.instance_variable_get(:@page_names)).to eq(options[:page_names])
        expect(helper_with_options.instance_variable_get(:@base_uri)).to eq(options[:base_uri])
        expect(helper_with_options.instance_variable_get(:@pagelist_suffix)).to eq(options[:pagelist_suffix])
      end
    end
  end

  describe '#parse_inline' do
    let(:str) { '[[dummy:http://dummy.com]]' }
    let(:expected) { %(<a class="outlink" href="http://dummy.com">dummy</a>) }
    it 'returns a correct result' do
      expect(helper.parse_inline(str)).to eq(expected)
    end
  end

  context 'private methods' do
    describe '#inline_re' do
      it 'returns a correct result' do
        helper.send(:inline_re)
        expect(helper.instance_variable_get(:@inline_re)).not_to eq(nil)
      end
    end

    describe '#a_href' do
      let(:uri) { 'http://dummy.com' }
      let(:label) { 'dummy link' }
      let(:cssclass) { 'dummy_css_class' }
      let(:expected) { %(<a class="dummy_css_class" href="http://dummy.com">dummy link</a>) }

      it 'returns a correct result' do
        expect(helper.send(:a_href, uri, label, cssclass)).to eq(expected)
      end
    end

    describe '#autolink_re' do
      let(:options) { { page_names: %w(abc defg hijk) } }
      it 'carries names whose lengths are greater than 3 only' do
        expect(helper_with_options.instance_variable_get(:@page_names)).to eq(options[:page_names])
        expect(helper_with_options.send(:autolink_re)).to eq(/defg|hijk/)
      end
    end

    describe '#page_uri' do
      let(:page_name) { 'a sample page' }
      it 'returns a correct uri' do
        expect(helper.send(:page_uri, page_name)).to eq('/a%20sample%20page/')
      end
    end
  end
end
