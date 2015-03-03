require "spec_helper"
require "tempfile"
require "erb"

describe MetricFu::Template do
  before(:each) do
    @template =  Template.new
  end

  describe "#erbify" do
    it "should evaluate a erb doc" do
      section = "section"
      erb = double("erb")
      expect(erb).to receive(:result)
      expect(@template).to receive(:template).and_return("foo")
      expect(@template).to receive(:erb_template_source).with("foo").and_return(erb)
      @template.send(:erbify, section)
    end
  end

  describe "#template_exists? " do
    before(:each) do
      @section = double("section")
    end

    describe "if the template exists" do
      it "should return true" do
        Tempfile.open("file") do |file|
          expect(@template).to receive(:template).with(@section).and_return(file.path)
          result = @template.send(:template_exists?, @section)
          expect(result).to be_truthy
        end
      end
    end

    describe "if the template does not exist" do
      it "should return false" do
        path = "path"
        expect(@template).to receive(:template).with(@section).and_return(path)
        result = @template.send(:template_exists?, @section)
        expect(result).to be_falsey
      end
    end
  end

  describe "#create_instance_var" do
    it "should set an instance variable with the passed contents" do
      section = "section"
      contents = "contents"
      @template.send(:create_instance_var, section, contents)
      expect(@template.instance_variable_get(:@section)).to eq(contents)
    end
  end

  describe "#template" do
    it "should generate the filename of the template file" do
      section = double("section")
      allow(section).to receive(:to_s).and_return("section")
      expect(@template).to receive(:template_directory).and_return("dir")
      result = @template.send(:template, section)
      expect(result).to eq("dir/section.html.erb")
    end
  end

  describe "#output_filename" do
    it "should generate the filename of the output file" do
      section = double("section")
      expect(section).to receive(:to_s).and_return("section")
      result = @template.send(:output_filename, section)
      expect(result).to eq("section.html")
    end
  end

  describe "#inline_css" do
    it "should return the contents of a css file" do
      css = "mycss.css"
      dir = File.join(MetricFu.lib_dir, "templates", css)
      contents = "css contents"
      expect(MetricFu::Utility).to receive(:binread).with(dir).and_return(contents)
      result = @template.send(:inline_css, css)
      expect(result).to eq(contents)
    end
  end

  describe "#link_to_filename " do
    describe "when on OS X" do
      before(:each) do
        config = double("configuration")
        allow(config).to receive(:osx?).and_return(true)
        allow(config).to receive(:platform).and_return("universal-darwin-9.0")
        allow(config).to receive(:templates_option).with("darwin_txmt_protocol_no_thanks").and_return(false)
        allow(config).to receive(:templates_option).with("link_prefix").and_return(nil)
        allow(MetricFu).to receive(:configuration).and_return(config)
      end

      it "should return a textmate protocol link" do
        expect(@template).to receive(:complete_file_path).with("filename").and_return("/expanded/filename")
        result = @template.send(:link_to_filename, "filename")
        expect(result).to eql("<a href='txmt://open/?url=file://" \
                         + "/expanded/filename'>filename</a>")
      end

      it "should do the right thing with a filename that starts with a slash" do
        expect(@template).to receive(:complete_file_path).with("/filename").and_return("/expanded/filename")
        result = @template.send(:link_to_filename, "/filename")
        expect(result).to eql("<a href='txmt://open/?url=file://" \
                         + "/expanded/filename'>/filename</a>")
      end

      it "should include a line number" do
        expect(@template).to receive(:complete_file_path).with("filename").and_return("/expanded/filename")
        result = @template.send(:link_to_filename, "filename", 6)
        expect(result).to eql("<a href='txmt://open/?url=file://" \
                         + "/expanded/filename&line=6'>filename:6</a>")
      end

      describe "but no thanks for txtmt" do
        before(:each) do
          config = double("configuration")
          allow(config).to receive(:osx?).and_return(true)
          allow(config).to receive(:platform).and_return("universal-darwin-9.0")
          allow(config).to receive(:templates_option).with("darwin_txmt_protocol_no_thanks").and_return(true)
          allow(config).to receive(:templates_option).with("link_prefix").and_return("file:/")
          allow(MetricFu).to receive(:configuration).and_return(config)
          expect(@template).to receive(:complete_file_path).and_return("filename")
        end

        it "should return a file protocol link" do
          name = "filename"
          result = @template.send(:link_to_filename, name)
          expect(result).to eq("<a href='file://filename'>filename</a>")
        end
      end

      describe "and given link text" do
        it "should use the submitted link text" do
          expect(@template).to receive(:complete_file_path).with("filename").and_return("/expanded/filename")
          result = @template.send(:link_to_filename, "filename", 6, "link content")
          expect(result).to eql("<a href='txmt://open/?url=file://" \
                           + "/expanded/filename&line=6'>link content</a>")
        end
      end
    end

    describe "when on other platforms"  do
      before(:each) do
        config = double("configuration")
        expect(config).to receive(:osx?).and_return(false)
        allow(config).to receive(:templates_option).with("link_prefix").and_return("file:/")
        allow(MetricFu).to receive(:configuration).and_return(config)
        expect(@template).to receive(:complete_file_path).and_return("filename")
      end

      it "should return a file protocol link" do
        name = "filename"
        result = @template.send(:link_to_filename, name)
        expect(result).to eq("<a href='file://filename'>filename</a>")
      end
    end
    describe "when configured with a link_prefix" do
      before(:each) do
        config = double("configuration")
        allow(config).to receive(:templates_option).with("darwin_txmt_protocol_no_thanks").and_return(true)
        allow(config).to receive(:templates_option).with("link_prefix").and_return("http://example.org/files")
        allow(config).to receive(:osx?).and_return(true)
        allow(MetricFu).to receive(:configuration).and_return(config)
        expect(@template).to receive(:complete_file_path).and_return("filename")
      end

      it "should return a http protocol link" do
        name = "filename"
        result = @template.send(:link_to_filename, name)
        expect(result).to eq("<a href='http://example.org/files/filename'>filename</a>")
      end
    end

    context "given an absolute path" do
      it "returns a link with that absolute path" do
        name = "/some/file.rb"
        result = @template.send(:link_to_filename, name)
        expect(result).to eq("<a href='file:///some/file.rb'>/some/file.rb</a>")
      end
    end

    context "given a relative path" do
      it "returns a link with the absolute path" do
        name = "./some/file.rb"
        expected = File.expand_path(name)
        result = @template.send(:link_to_filename, name)
        expect(result).to eq("<a href='file://#{expected}'>./some/file.rb</a>")
      end
    end
  end

  describe "#cycle" do
    it "should return the first_value passed if iteration passed is even" do
      first_val = "first"
      second_val = "second"
      iter = 2
      result = @template.send(:cycle, first_val, second_val, iter)
      expect(result).to eq(first_val)
    end

    it "should return the second_value passed if iteration passed is odd" do
      first_val = "first"
      second_val = "second"
      iter = 1
      result = @template.send(:cycle, first_val, second_val, iter)
      expect(result).to eq(second_val)
    end
  end

  describe "#render_partial" do
    it "should erbify a partial with the name prefixed with an underscore" do
      expect(@template).to receive(:erbify).with("_some_partial")
      @template.send(:render_partial, "some_partial")
    end

    it "should set the given instance variables" do
      variables = { answer: 42 }
      allow(@template).to receive(:erbify)
      expect(@template).to receive(:create_instance_vars).with(variables)
      @template.send(:render_partial, "some_partial", variables)
    end
  end

  describe "#create_instance_vars" do
    it "should set the given instance variables" do
      @template.send(:create_instance_vars, answer: 42)
      expect(@template.instance_variable_get(:@answer)).to eq(42)
    end
  end
end
