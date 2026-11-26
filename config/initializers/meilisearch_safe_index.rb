# frozen_string_literal: true

# O meilisearch-rails 0.16.0 sempre enfileira um `indexCreation` no SafeIndex,
# mesmo quando o index já existe. Como vários models compartilham os mesmos
# UIDs (threat, hero e battle), isso gera tasks `index_already_exists`.
#
# Esta extensão faz a checagem antes de criar. Não dá para apenas resgatar
# `index_already_exists`, porque o create_index é assíncrono: a falha aparece
# depois na fila de tasks do Meilisearch, não como exceção no Ruby.
module MeilisearchSafeIndexCreateOnlyIfMissing
  def initialize(index_uid, raise_on_failure, options)
    client = ::Meilisearch::Rails.client
    primary_key = options[:primary_key] || ::Meilisearch::Rails::IndexSettings::DEFAULT_PRIMARY_KEY
    @raise_on_failure = raise_on_failure.nil? || raise_on_failure

    # Mantém o mesmo comportamento de log/raise do gem para erros de API/timeout.
    ::Meilisearch::Rails::SafeIndex.log_or_throw(nil, @raise_on_failure) do
      create_index_unless_exists(client, index_uid, primary_key)
    end

    @index = client.index(index_uid)
  end

  private

  def create_index_unless_exists(client, index_uid, primary_key)
    return if index_exists?(client, index_uid)

    client.create_index(index_uid, { primary_key: primary_key })
  end

  def index_exists?(client, index_uid)
    client.fetch_index(index_uid)
    true
  rescue ::Meilisearch::ApiError => e
    raise if e.ms_code != 'index_not_found'

    false
  end
end

::Meilisearch::Rails::SafeIndex.prepend(MeilisearchSafeIndexCreateOnlyIfMissing)
