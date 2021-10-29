# frozen_string_literal: true

require 'spec_helper'
require 'rswag/specs'

RSpec.configure do |config|
  # Specify a root folder where Swagger JSON files are generated
  # NOTE: If you're using the rswag-api to serve API descriptions, you'll need
  # to ensure that it's configured to serve Swagger from the same folder
  config.swagger_root = Rails.root.join('../../docs').to_s # Rails.root is a dummy app

  # Define one or more Swagger documents and provide global metadata for each one
  # When you run the 'rswag:specs:swaggerize' rake task, the complete Swagger will
  # be generated at the provided relative path under swagger_root
  # By default, the operations defined in spec files are added to the first
  # document below. You can override this behavior by adding a swagger_doc tag to the
  # the root example_group in your specs, e.g. describe '...', swagger_doc: 'v2/swagger.json'
  config.swagger_docs = {
    'v2/platform/index.yaml' => {
      openapi: '3.0.3',
      info: {
        title: 'Platform API v2',
        contact: {
          name: 'Spark Solutions',
          url: 'https://sparksolutions.co',
          email: 'we@sparksolutions.co',
        },
        description: 'Spree Platform API v2',
        version: 'v2'
      },
      paths: {},
      servers: [
        {
          url: 'https://{defaultHost}',
          variables: {
            defaultHost: {
              default: 'localhost:3000'
            }
          }
        }
      ],
      tags: [
        { name: 'Addresses' },
        { name: 'Adjustments' },
        { name: 'Classifications' },
        { name: 'Countries' },
        { name: 'CMS Pages' },
        { name: 'CMS Sections' },
        { name: 'Digital Assets' },
        { name: 'Digital Links' },
        { name: 'Line Items' },
        { name: 'Menus' },
        { name: 'Menu Items' },
        { name: 'Option Types' },
        { name: 'Option Values' },
        { name: 'Orders' },
        { name: 'Payments' },
        { name: 'Promotion Categories' },
        { name: 'Shipments' },
        { name: 'Shipping Categories' },
        { name: 'Shipping Methods' },
        { name: 'Taxons' },
        { name: 'Users' },
        { name: 'Webhook Events' },
        { name: 'Webhook Subscribers' },
        { name: 'Wishlists' },
        { name: 'Wished Items' },
        { name: 'Variants' }
      ],
      components: {
        securitySchemes: {
          bearer_auth: {
            type: :http,
            scheme: :bearer
          }
        },
        schemas: {

          # Address
          address_params: {
            type: :object,
            properties: {
              address: {
                type: :object,
                required: %w[country_id address1 city zipcode phone firstname lastname],
                properties: {
                  country_id: { type: :string, example: '224' },
                  state_id: { type: :string, example: '516' },
                  state_name: { type: :string, example: 'New York' },
                  address1: { type: :string, example: '5th ave' },
                  address2: { type: :string, example: '1st suite' },
                  city: { type: :string, example: 'NY' },
                  zipcode: { type: :string, example: '10001' },
                  phone: { type: :string, example: '+1 123 456 789' },
                  alternative_phone: { type: :string },
                  firstname: { type: :string, example: 'John' },
                  lastname: { type: :string, example: 'Snow' },
                  label: { type: :string, example: 'My home address' },
                  company: { type: :string, example: 'Vendo Cloud Inc' },
                  user_id: { type: :string }
                }
              }
            },
            required: %w[address],
            'x-internal': true
          },

          # Adjustment
          adjustment_params: {
            type: :object,
            properties: {
              adjustment: {
                type: :object,
                required: %w[order_id label adjustable_id adjustable_type],
                properties: {
                  order_id: { type: :string },
                  label: { type: :string, example: 'Shipping costs' },
                  adjustable_id: { type: :string },
                  adjustable_type: { type: :string, example: 'Spree::LineItem' },
                  source_id: { type: :string },
                  source_type: { type: :string, example: 'Spree::TaxRate' },
                  amount: { type: :number, example: 10.90 },
                  mandatory: { type: :boolean },
                  eligible: { type: :boolean },
                  state: { type: :string, example: 'closed', default: 'open', enum: ['closed', 'open'] },
                  included: { type: :boolean, example: true, default: false },
                }
              }
            },
            required: %w[adjustment],
            'x-internal': true
          },

          # Classification
          classification_params: {
            type: :object,
            properties: {
              classification: {
                type: :object,
                required: %w[product_id taxon_id position],
                properties: {
                  product_id: { type: :string, example: '1' },
                  taxon_id: { type: :string, example: '1' },
                  position: { type: :integer, example: 1 }
                }
              }
            },
            required: %w[classification],
            'x-internal': true
          },

          # CMS Page
          cms_page_params: {
            type: :object,
            properties: {
              cms_page: {
                type: :object,
                required: %w[title locale],
                properties: {
                  title: { type: :string },
                  meta_title: { type: :string },
                  content: { type: :string, },
                  meta_description: { type: :string },
                  visible: { type: :string },
                  slug: { type: :string },
                  locale: { type: :string }
                }
              }
            },
            required: %w[cms_page],
            'x-internal': true
          },

          # CMS Section
          cms_section_params: {
            type: :object,
            properties: {
              cms_section: {
                type: :object,
                required: %w[name cms_page_id],
                properties: {
                  name: { type: :string },
                  cms_page_id: { type: :string },
                  content: { type: :object, },
                  settings: { type: :object },
                  fit: { type: :string },
                  destination: { type: :string }
                }
              }
            },
            required: %w[cms_section],
            'x-internal': true
          },
          cms_section_reposition_params: {
            type: :object,
            properties: {
              new_position_idx: { type: :integer }
            },
            required: %w[new_position_idx],
            'x-internal': true
          },

          # Digital
          digital_params: {
            type: :object,
            properties: {
              'digital[attachment]': { type: :string, format: :binary },
              "digital[variant_id]": { type: :string, example: '123' }
            },
            required: ['digital[attachment]', 'digital[variant_id]'],
            'x-internal': true
          },

          # Digital Link
          digital_link_params: {
            type: :object,
            properties: {
              digital_link: {
                type: :object,
                required: %w[line_item_id digital_id],
                properties: {
                  access_counter: { type: :integer, example: 0 },
                  line_item_id: { type: :string, example: '1' },
                  digital_id: { type: :string, example: '1' }
                }
              }
            },
            required: %w[digital_link],
            'x-internal': true
          },

          # Line Item
          line_item_params: {
            type: :object,
            properties: {
              line_item: {
                type: :object,
                required: %w[order_id variant_id quantity],
                properties: {
                  order_id: { type: :string, example: '1' },
                  variant_id: { type: :string, example: '1' },
                  quantity: { type: :integer, example: 2 }
                }
              }
            },
            required: %w[line_item],
            'x-internal': true
          },

          # Menu
          menu_params: {
            type: :object,
            properties: {
              menu: {
                type: :object,
                required: %w[name location locale],
                properties: {
                  name: { type: :string },
                  location: { type: :string },
                  locale: { type: :string }
                }
              }
            },
            required: %w[menu],
            'x-internal': true
          },

          # Menu Item
          menu_item_params: {
            type: :object,
            properties: {
              menu_item: {
                type: :object,
                required: %w[name menu_id],
                properties: {
                  name: { type: :string },
                  code: { type: :string },
                  subtitle: { type: :string },
                  destination: { type: :string },
                  menu_id: { type: :string },
                  new_window: { type: :boolean },
                  item_type: { type: :string },
                  linked_resource_type: { type: :string },
                  linked_resource_id: { type: :integer }
                }
              }
            },
            required: %w[menu_item],
            'x-internal': true
          },

          menu_item_reposition_params: {
            type: :object,
            properties: {
              new_parent_id: { type: :integer },
              new_position_idx: { type: :integer }
            },
            required: %w[new_parent_id new_position_idx],
            'x-internal': true
          },

          # Option Type
          option_type_params: {
            type: :object,
            properties: {
              option_type: {
                type: :object,
                required: %w[name presentation],
                properties: {
                  name: { type: :string, example: 'color' },
                  presentation: { type: :string, example: 'Color' }
                }
              }
            },
            required: %w[option_type],
            'x-internal': true
          },

          # Option Value
          option_value_params: {
            type: :object,
            properties: {
              option_value: {
                type: :object,
                required: %w[name presentation],
                properties: {
                  name: { type: :string, example: 'red' },
                  presentation: { type: :string, example: 'Red' }
                }
              }
            },
            required: %w[option_value],
            'x-internal': true
          },

          # Order
          order_params: {
            type: :object,
            properties: {
              order: {
                type: :object,
                properties: {
                  item_total: { type: :number, example: 170.90 },
                  total: { type: :number, example: 190.90 },
                  state: { type: :string, example: 'complete', enum: %w[cart address delivery payment confirm complete canceled] },
                  adjustment_total: { type: :number, example: 20.0 },
                  user_id: { type: :string, example: '1' },
                  completed_at: { type: :string, format: :date_time, example: Time.current },
                  bill_address_id: { type: :string, example: '1' },
                  ship_address_id: { type: :string, example: '1' },
                  payment_total: { type: :number, example: 190.90 },
                  shipment_state: { type: :string, example: 'shipped', enum: Spree::Order::SHIPMENT_STATES },
                  payment_state: { type: :string, example: 'paid', enum: Spree::Order::PAYMENT_STATES },
                  email: { type: :string, format: :email, example: 'hi@getvendo.com' },
                  special_instructions: { type: :string, example: 'I need it ASAP!' },
                  currency: { type: :string, example: 'USD' },
                  last_ip_address: { type: :string, example: '127.0.0.1' },
                  created_by_id: { type: :string, example: '1' },
                  shipment_total: { type: :number, example: 10.0 },
                  additional_tax_total: { type: :number, example: 10.0 },
                  promo_total: { type: :number, example: 0.0 },
                  channel: { type: :string, example: 'online' },
                  included_tax_total: { type: :number, example: 0.0 },
                  item_count: { type: :integer, example: 2 },
                  approver_id: { type: :string },
                  approved_at: { type: :string, format: :date_time, example: Time.current },
                  confirmation_delivered: { type: :boolean, example: true, default: false },
                  considered_risky: { type: :boolean, example: true, default: false },
                  canceled_at: { type: :string, format: :date_time },
                  canceler_id: { type: :string },
                  taxable_adjustment_total: { type: :number, example: 170.90 },
                  non_taxable_adjustment_total: { type: :number, example: 10.0 },
                  store_owner_notification_delivered: { type: :boolean, example: true, default: false },
                  bill_address_attributes: { '$ref': '#/components/schemas/address_params' },
                  ship_address_attributes: { '$ref': '#/components/schemas/address_params' },
                  line_items_attributes: {
                    type: :array,
                    items: { '$ref': '#/components/schemas/line_item_params' }
                  }
                }
              }
            },
            required: %w[order],
            'x-internal': true
          },

          # Product
          product_params: {
            type: :object,
            properties: {
              product: {
                type: :object,
                required: %w[name price shipping_category_id],
                properties: {
                  name: { type: :string },
                  description: { type: :string },
                  available_on: { type: :string },
                  discontinue_on: { type: :string },
                  permalink: { type: :string },
                  meta_description: { type: :string },
                  meta_keywords: { type: :string },
                  price: { type: :string },
                  sku: { type: :string },
                  deleted_at: { type: :string },
                  prototype_id: { type: :string },
                  option_values_hash: { type: :string },
                  weight: { type: :string },
                  height: { type: :string },
                  width: { type: :string },
                  depth: { type: :string },
                  shipping_category_id: { type: :string },
                  tax_category_id: { type: :string },
                  cost_currency: { type: :string },
                  cost_price: { type: :string },
                  compare_at_price: { type: :string },
                  option_type_ids: { type: :string },
                  taxon_ids: { type: :string }
                }
              }
            },
            required: %w[product],
            'x-internal': true
          },

          # Promotion Category
          promotion_category_params: {
            type: :object,
            properties: {
              promotion_category: {
                type: :object,
                required: %w[name],
                properties: {
                  name: { type: :string, example: 'Promotions Used in 2021' },
                  code: { type: :string, example: '2021-PROMOS' }
                }
              }
            },
            required: %w[promotion_category],
            'x-internal': true
          },

          # Shipping Category
          shipping_category_params: {
            type: :object,
            properties: {
              shipping_category: {
                type: :object,
                required: %w[name],
                properties: {
                  name: { type: :string, example: 'Another Category' }
                }
              }
            },
            required: %w[shipping_category],
            'x-internal': true
          },

          # Shipping Method
          shipping_method_params: {
            type: :object,
            properties: {
              shipping_method: {
                type: :object,
                required: %w[name display_on shipping_category_ids],
                properties: {
                  name: { type: :string, example: 'DHL Express' },
                  admin_name: { type: :string, example: 'DHL Area Code D' },
                  code: { type: :string, example: 'DHL-A-D' },
                  tracking_url: { type: :string, example: 'dhlexpress.com?tracking=' },
                  display_on: { type: :string, example: 'both', enum: ['both', 'back_end', 'front_end'] },
                  tax_category_id: { type: :string, example: '1' },
                  shipping_category_ids: {
                    type: :array,
                    items: {
                      allOf: [
                        { type: :string, example: '2' }
                      ]
                    }
                  },
                  calculator_attributes: { '$ref': '#/components/schemas/shipping_calculator_params' },
                }
              }
            },
            required: %w[shipping_method],
            'x-internal': true
          },
          shipping_calculator_params: {
            type: :object,
            properties: {
              type: { type: :string, example: 'Spree::Calculator::Shipping::FlatPercentItemTotal', enum: ['Spree::Calculator::Shipping::DigitalDelivery', 'Spree::Calculator::Shipping::FlatPercentItemTotal', 'Spree::Calculator::Shipping::FlatRate', 'Spree::Calculator::Shipping::FlexiRate', 'Spree::Calculator::Shipping::PerItem', 'Spree::Calculator::Shipping::PriceSack'] }
            },
            required: %w[type],
            'x-internal': true
          },

          # Taxon
          taxon_params: {
            type: :object,
            properties: {
              taxon: {
                type: :object,
                required: %w[name taxonomy_id],
                properties: {
                  taxonomy_id: { type: :string },
                  parent_id: { type: :string },
                  name: { type: :string }
                }
              }
            },
            required: %w[taxon],
            'x-internal': true
          },

          # User
          user_params: {
            type: :object,
            properties: {
              user: {
                type: :object,
                required: %w[email password password_confirmation],
                properties: {
                  email: { type: :string },
                  password: { type: :string },
                  password_confirmation: { type: :string },
                  ship_address_id: { type: :string },
                  bill_address_id: { type: :string },
                }
              }
            },
            required: %w[user],
            'x-internal': true
          },

          # Webhook
          webhook_subscriber_params: {
            type: :object,
            properties: {
              subscriber: {
                type: :object,
                required: %w[url],
                properties: {
                  active: { type: :boolean, example: true, default: false },
                  subscriptions: {
                    type: :array,
                    items: {
                      allOf: [
                        { type: :string, example: 'order.completed' }
                      ]
                    },
                    example: ['order.created', 'order.completed', 'product.updated'],
                    default: []
                  },
                  url: { type: :string, example: 'https://www.url.com/' }
                }
              }
            },
            required: %w[subscriber],
            'x-internal': true
          },

          # Wishlist
          wishlist_params: {
            type: :object,
            properties: {
              wishlist: {
                type: :object,
                required: %w[name user_id],
                properties: {
                  name: { type: :string },
                  user_id: { type: :string },
                  is_default: { type: :boolean },
                  is_private: { type: :boolean }
                }
              }
            },
            required: %w[wishlist],
            'x-internal': true
          },

          # Wished Item
          wished_item_params: {
            type: :object,
            properties: {
              wished_item: {
                type: :object,
                required: %w[wishlist_id variant_id quantity],
                properties: {
                  wishlist_id: { type: :string },
                  variant_id: { type: :string },
                  quantity: {
                    type: :integer,
                    description: 'Must be an integer greater than 0'
                  }
                }
              }
            },
            required: %w[wished_item],
            'x-internal': true
          },

          # Nested Parameters
          amount_param: {
            type: :object,
            properties: {
              amount: { type: :number }
            },
            'x-internal': true
          },

          coupon_code_param: {
            type: :object,
            properties: {
              coupon_code: { type: :string }
            },
            'x-internal': true
          },
          resources_list: {
            type: :object,
            properties: {
              data: {
                type: :array,
                items: {
                  allOf: [
                    { '$ref' => '#/components/schemas/resource_properties' }
                  ]
                }
              },
              meta: {
                type: :object,
                properties: {
                  count: { type: :integer },
                  total_count: { type: :integer },
                  total_pages: { type: :integer }
                },
                required: %w[count total_count total_pages]
              },
              links: {
                type: :object,
                properties: {
                  self: { type: :string },
                  next: { type: :string },
                  prev: { type: :string },
                  last: { type: :string },
                  first: { type: :string }
                },
                required: %w[self next prev last first]
              }
            },
            required: %w[data meta links],
            'x-internal': true
          },
          resource_properties: {
            type: :object,
            properties: {
              id: { type: :string },
              type: { type: :string },
              attributes: { type: :object },
              relationships: { type: :object }
            },
            required: %w[id type attributes],
            'x-internal': true
          },
          resource: {
            type: :object,
            properties: {
              data: { '$ref' => '#/components/schemas/resource_properties' },
            },
            required: %w[data],
            'x-internal': true
          },
          error: {
            type: :object,
            properties: {
              error: { type: :string },
            },
            required: %w[error],
            'x-internal': true
          },
          validation_errors: {
            type: :object,
            properties: {
              error: { type: :string },
              errors: { type: :object }
            },
            required: %w[error errors],
            'x-internal': true
          }
        }
      }
    }
  }

  # Specify the format of the output Swagger file when running 'rswag:specs:swaggerize'.
  # The swagger_docs configuration option has the filename including format in
  # the key, this may want to be changed to avoid putting yaml in json files.
  # Defaults to json. Accepts ':json' and ':yaml'.
  config.swagger_format = :yaml

  # auto generate examples based on response
  config.after do |example|
    next if example.metadata[:swagger].nil?
    next if response.nil? || response.body.blank? || example.metadata[:response][:schema].nil?

    example.metadata[:response][:content] = {
      'application/vnd.api+json' => {
        examples: {
          'Example': {
            value: JSON.parse(response.body, symbolize_names: true)
          },
        },
        schema: {
          '$ref': example.metadata[:response][:schema]['$ref']
        }
      }
    }
  end
end
