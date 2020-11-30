# require "CanvasGrab/version"
require 'json'
require 'nokogiri'


module CanvasGrab
  class Error < StandardError; end

  class Grabber
    attr_accessor :manifest, :canvases, :id_prefix

    def initialize(args)
      raise IOError, "File at `#{args[:manifest]}' is not found" unless File.exist?(args[:manifest])
      @manifest = JSON.parse(File.read(args[:manifest]))
      @id_prefix = args[:id_prefix]
      @canvases = []
      manifest["sequences"].first["canvases"].each do |canvas|
        @canvases << @CanvasGrab::Canvas.new(canvas)
      end
    end

    def surface_grp
      builder = Nokogiri::XML::Builder.new do |xml|
        xml.surfaceGrp {
          canvases.each do |canvas|
            xml.surface(id: id_prefix + "_" + canvas.label, source: canvas.id, n: canvas.label) {
              xml.graphic(url: canvas.imageURL)
            }
          end
        }
      end
      builder.to_xml
    end
  end

  class Canvas
    attr_accessor :json
    def initialize(canvas)
      @json = canvas
    end

    def id
      json["@id"]
    end

    def label
      json["label"]
    end

    def imageURL
      json["images"].first["resource"]["@id"]
    end

    def to_xml
      builder = Nokogiri::XML::Builder.new do |xml|
        xml.surface(source: id, n: label) {
          xml.graphic(url: imageURL) }
      end
      builder.to_xml
    end
  end
end
