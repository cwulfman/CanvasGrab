RSpec.describe CanvasGrab do
  it "has a version number" do
    expect(CanvasGrab::VERSION).not_to be nil
  end
end

RSpec.describe CanvasGrab::Grabber do
  subject(:grabber) { described_class.new(manifest: file, id_prefix: "b18_f01") }
  let(:file) { File.dirname(__FILE__) + "/fixtures/manifest.json" }

  it "has a manifest" do
    expect(grabber.manifest).to_not be_empty
    expect(grabber.id_prefix).to eq("b18_f01")
  end

  it "has canvases" do
    expect(grabber.canvases.count).to eq(101)
  end

  it "has canvases with properties" do
    canvas = grabber.canvases.first
    expect(canvas.id).to eq("https://figgy.princeton.edu/concern/scanned_resources/229e261f-cd48-4d4b-8f08-5de6d95a2dd8/manifest/canvas/40a7fd43-5d5a-4ed0-9d71-5492bfcbde29")
    expect(canvas.label).to eq("1")
    expect(canvas.imageURL).to eq("https://iiif-cloud.princeton.edu/iiif/2/1d%2Ffb%2Fc6%2F1dfbc60b2caa4ad283d956d6c2814f16%2Fintermediate_file/full/1000,/0/default.jpg")
  end

  it "can emit xml" do
    canvas = grabber.canvases.first
    xml_doc = Nokogiri::XML(canvas.to_xml)
    path = xml_doc.xpath("//graphic/@url")
    expect(path.count).to eq(1)
    expect(path.first.to_str).to eq("https://iiif-cloud.princeton.edu/iiif/2/1d%2Ffb%2Fc6%2F1dfbc60b2caa4ad283d956d6c2814f16%2Fintermediate_file/full/1000,/0/default.jpg")
  end

  it "can emit a surfaceGrp" do
    surface_grp = grabber.surface_grp
    xml_doc = Nokogiri::XML(surface_grp)
    path = xml_doc.xpath("//surface")
    expect(path.count).to eq(101)
  end
end
