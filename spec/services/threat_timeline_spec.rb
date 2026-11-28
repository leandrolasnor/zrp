# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ThreatTimeline do
  let(:event_store) { Rails.configuration.event_store }

  before do
    event_store.publish(
      UN::AlertReceived.new(data: {
        'monsterName' => 'Godzilla',
        'dangerLevel' => 'God',
        'location' => { 'lat' => '1.5', 'lng' => '-2.5' }
      }),
      stream_name: 'Threat#1'
    )
    event_store.publish(
      ResourceAllocated.new(data: {
        'heroes' => [{ 'name' => 'Superman', 'rank' => 's' }],
        'battles' => [{ 'score' => 90, 'finished_at' => '2024-01-15T10:05:00Z' }]
      }),
      stream_name: 'Threat#1'
    )
    event_store.publish(
      ResourceDeallocated.new(data: {}),
      stream_name: 'Threat#2'
    )
    event_store.publish(
      ResourceNotAllocated.new(data: ['#<AllocateResource::Model::Hero:0x00007e3bfd6de248>']),
      stream_name: 'Threat#3'
    )
    event_store.publish(
      ResourceNotAllocated.new(data: [{ 'name' => 'Batman', 'rank' => 'a' }]),
      stream_name: 'Threat#4'
    )
  end

  it 'groups the RES events by threat id in chronological order' do
    result = described_class.call([1, 2, 1])

    expect(result.keys).to contain_exactly(1, 2)
    expect(result[1].map { |event| event[:type] }).to eq(%w[AlertReceived ResourceAllocated])
    expect(result[1].first[:title]).to eq('Threat detected')
    expect(result[1].first[:details]['monsterName']).to eq('Godzilla')
    expect(result[1].first[:occurred_at]).to be_present
    expect(result[2].map { |event| event[:type] }).to eq(['ResourceDeallocated'])
  end

  it 'ignores stringified heroes from legacy ResourceNotAllocated events' do
    result = described_class.call([3, 4])

    expect(result[3].first[:details]).to eq([])
    expect(result[4].first[:details]).to eq([{ 'name' => 'Batman', 'rank' => 'a' }])
  end

  it 'returns an empty hash when there are no threat ids' do
    expect(described_class.call([])).to eq({})
  end

  it 'omits threats with no events' do
    expect(described_class.call([99])).to eq({})
  end
end
