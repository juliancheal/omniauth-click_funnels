# frozen_string_literal: true

module Omniauth
  module ClickFunnels
    class Client
      attr_reader :oauth_token, :click_funnels_team, :api_endpoint

      def initialize(oauth_token: nil, click_funnels_team: nil)
        @oauth_token = oauth_token
        @click_funnels_team = click_funnels_team

        @api_endpoint = "https://#{click_funnels_team}.myclickfunnels.test/api/v2/"
      end

      def get(endpoint)
        request(
          http_method: :get,
          endpoint: endpoint
        )
      end

      def put(endpoint, params)
        request(
          http_method: :put,
          endpoint: endpoint,
          params: params
        )
      end

      private

      def client
        faraday_options = {
          request: {
            open_timeout: 1,
            read_timeout: 5,
            write_timeout: 5
          }
        }

        @_client ||= Faraday.new(api_endpoint) do |client|
          client.request :json
          client.response :json, content_type: "application/json"
          client.request :authorization, :bearer, oauth_token if oauth_token.present?
        end
      end

      def request(http_method:, endpoint:, params: {})
        response = client.public_send(http_method, endpoint, params)
        response.body
      end
    end
  end
end