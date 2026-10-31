require 'tmpdir'

RSpec.describe Roma::Storage::SQLite3Storage do
  # ROMA stores a value without an expiry with this one.
  NO_EXPIRY = 0x7fffffff

  let(:dir) { Dir.mktmpdir }
  after { FileUtils.rm_rf(dir) }

  def open_storage
    described_class.new.tap do |st|
      st.st_class = described_class
      st.storage_path = dir
      st.vn_list = [0, 1]
      st.divnum = 2
      st.opendb
    end
  end

  it "has a version number" do
    expect(Roma::Storage::Sqlite3::VERSION).not_to be nil
  end

  it "writes a file for each division" do
    open_storage.closedb
    expect(Dir.children(dir).sort).to eq(%w(0.sql3 1.sql3 status.log.1))
  end

  it "stores, updates and deletes values" do
    st = open_storage
    st.set(0, 'k1', 0, NO_EXPIRY, 'v1')
    expect(st.get(0, 'k1', 0)).to eq('v1')
    st.append(0, 'k1', 0, NO_EXPIRY, '+')
    expect(st.get(0, 'k1', 0)).to eq('v1+')
    st.set(1, 'n', 0, NO_EXPIRY, '1')
    st.incr(1, 'n', 0, 5)
    expect(st.get(1, 'n', 0)).to eq('6')
    st.delete(0, 'k1', 0)
    expect(st.get(0, 'k1', 0)).to be_nil
    st.closedb
  end

  it "stores binary values" do
    st = open_storage
    value = (0..255).map(&:chr).join.b
    st.set(0, "k\xff".b, 0, NO_EXPIRY, value)
    expect(st.get(0, "k\xff".b, 0)).to eq(value)
    st.closedb
  end

  it "does not return expired values" do
    st = open_storage
    st.set(0, 'k1', 0, Time.now.to_i - 1, 'v1')
    expect(st.get(0, 'k1', 0)).to be_nil
    st.closedb
  end

  it "keeps the values after it is reopened" do
    st = open_storage
    st.set(0, 'k1', 0, NO_EXPIRY, 'v1')
    st.closedb
    st = open_storage
    expect(st.get(0, 'k1', 0)).to eq('v1')
    expect(st.true_length).to eq(1)
    st.closedb
  end

  it "dumps the values of a vnode" do
    st = open_storage
    st.set(0, 'k1', 0, NO_EXPIRY, 'v1')
    st.set(0, 'k2', 0, NO_EXPIRY, 'v2')
    st.set(1, 'k3', 0, NO_EXPIRY, 'v3')
    dumps = []
    st.each_vn_dump(0) { |d| dumps << d }
    expect(dumps.size).to eq(2)
    st.closedb
  end

  it "cleans up the expired values" do
    st = open_storage
    st.each_clean_up_sleep = 0
    st.set(0, 'k1', 0, Time.now.to_i - 1, 'v1')
    st.set(0, 'k2', 0, NO_EXPIRY, 'v2')
    cleaned = []
    st.each_clean_up(Time.now.to_i - 100, { 0 => :primary }) { |k, vn| cleaned << [k, vn] }
    expect(cleaned).to eq([['k1', 0]])
    expect(st.true_length).to eq(1)
    st.closedb
  end

  it "tells its class in the stats" do
    st = open_storage
    expect(st.get_stat['storage.st_class']).to eq('SQLite3Storage')
    st.closedb
  end
end
