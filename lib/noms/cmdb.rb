#!ruby
# /* Copyright 2014 Evernote Corporation. All rights reserved.
#    Copyright 2013 Proofpoint, Inc. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# */

require 'noms/httpclient'
require 'uri'

class NOMS

end

class NOMS::CMDB < NOMS::HttpClient

  def config_key
    'cmdb'
  end

  def query(type, *condlist)
    do_request(:GET => "#{type}", :query => URI.encode(condlist.join('&')))
  end

  def key_field_of(type)
      case type
      when 'system'
          'fqdn'
      else
          'id'
      end
  end

  def system(hostname)
    do_request(:GET => "system/#{hostname}")
  end

  def system_audit(hostname)
    do_request(:GET => "inv_audit", :query => "entity_key=#{hostname}")
  end

  def get_or_assign_system_name(serial)
      do_request :GET => "pcmsystemname/#{serial}"
  end

  def update(type, obj, key=nil)
      key ||= obj[key_field_of(type)]
      do_request(:PUT => "#{type}/#{key}", :body => obj)
  end

  def tc_post(obj)
      do_request(:POST => "fact", :body => obj)
  end
  def environments
    do_request :GET => 'environments'
  end

  def environment(env)
    do_request :GET => "environments/#{env}"
  end

end
