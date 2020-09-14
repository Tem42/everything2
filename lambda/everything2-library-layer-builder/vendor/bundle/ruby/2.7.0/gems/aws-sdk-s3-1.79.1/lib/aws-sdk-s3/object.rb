# frozen_string_literal: true

# WARNING ABOUT GENERATED CODE
#
# This file is generated. See the contributing guide for more information:
# https://github.com/aws/aws-sdk-ruby/blob/master/CONTRIBUTING.md
#
# WARNING ABOUT GENERATED CODE

module Aws::S3

  class Object

    extend Aws::Deprecations

    # @overload def initialize(bucket_name, key, options = {})
    #   @param [String] bucket_name
    #   @param [String] key
    #   @option options [Client] :client
    # @overload def initialize(options = {})
    #   @option options [required, String] :bucket_name
    #   @option options [required, String] :key
    #   @option options [Client] :client
    def initialize(*args)
      options = Hash === args.last ? args.pop.dup : {}
      @bucket_name = extract_bucket_name(args, options)
      @key = extract_key(args, options)
      @data = options.delete(:data)
      @client = options.delete(:client) || Client.new(options)
      @waiter_block_warned = false
    end

    # @!group Read-Only Attributes

    # @return [String]
    def bucket_name
      @bucket_name
    end

    # @return [String]
    def key
      @key
    end

    # Specifies whether the object retrieved was (true) or was not (false) a
    # Delete Marker. If false, this response header does not appear in the
    # response.
    # @return [Boolean]
    def delete_marker
      data[:delete_marker]
    end

    # Indicates that a range of bytes was specified.
    # @return [String]
    def accept_ranges
      data[:accept_ranges]
    end

    # If the object expiration is configured (see PUT Bucket lifecycle), the
    # response includes this header. It includes the expiry-date and rule-id
    # key-value pairs providing object expiration information. The value of
    # the rule-id is URL encoded.
    # @return [String]
    def expiration
      data[:expiration]
    end

    # If the object is an archived object (an object whose storage class is
    # GLACIER), the response includes this header if either the archive
    # restoration is in progress (see RestoreObject or an archive copy is
    # already restored.
    #
    # If an archive copy is already restored, the header value indicates
    # when Amazon S3 is scheduled to delete the object copy. For example:
    #
    # `x-amz-restore: ongoing-request="false", expiry-date="Fri, 23 Dec 2012
    # 00:00:00 GMT"`
    #
    # If the object restoration is in progress, the header returns the value
    # `ongoing-request="true"`.
    #
    # For more information about archiving objects, see [Transitioning
    # Objects: General Considerations][1].
    #
    #
    #
    # [1]: https://docs.aws.amazon.com/AmazonS3/latest/dev/object-lifecycle-mgmt.html#lifecycle-transition-general-considerations
    # @return [String]
    def restore
      data[:restore]
    end

    # Last modified date of the object
    # @return [Time]
    def last_modified
      data[:last_modified]
    end

    # Size of the body in bytes.
    # @return [Integer]
    def content_length
      data[:content_length]
    end

    # An ETag is an opaque identifier assigned by a web server to a specific
    # version of a resource found at a URL.
    # @return [String]
    def etag
      data[:etag]
    end

    # This is set to the number of metadata entries not returned in
    # `x-amz-meta` headers. This can happen if you create metadata using an
    # API like SOAP that supports more flexible metadata than the REST API.
    # For example, using SOAP, you can create metadata whose values are not
    # legal HTTP headers.
    # @return [Integer]
    def missing_meta
      data[:missing_meta]
    end

    # Version of the object.
    # @return [String]
    def version_id
      data[:version_id]
    end

    # Specifies caching behavior along the request/reply chain.
    # @return [String]
    def cache_control
      data[:cache_control]
    end

    # Specifies presentational information for the object.
    # @return [String]
    def content_disposition
      data[:content_disposition]
    end

    # Specifies what content encodings have been applied to the object and
    # thus what decoding mechanisms must be applied to obtain the media-type
    # referenced by the Content-Type header field.
    # @return [String]
    def content_encoding
      data[:content_encoding]
    end

    # The language the content is in.
    # @return [String]
    def content_language
      data[:content_language]
    end

    # A standard MIME type describing the format of the object data.
    # @return [String]
    def content_type
      data[:content_type]
    end

    # The date and time at which the object is no longer cacheable.
    # @return [Time]
    def expires
      data[:expires]
    end

    # @return [String]
    def expires_string
      data[:expires_string]
    end

    # If the bucket is configured as a website, redirects requests for this
    # object to another object in the same bucket or to an external URL.
    # Amazon S3 stores the value of this header in the object metadata.
    # @return [String]
    def website_redirect_location
      data[:website_redirect_location]
    end

    # If the object is stored using server-side encryption either with an
    # AWS KMS customer master key (CMK) or an Amazon S3-managed encryption
    # key, the response includes this header with the value of the
    # server-side encryption algorithm used when storing this object in
    # Amazon S3 (for example, AES256, aws:kms).
    # @return [String]
    def server_side_encryption
      data[:server_side_encryption]
    end

    # A map of metadata to store with the object in S3.
    # @return [Hash<String,String>]
    def metadata
      data[:metadata]
    end

    # If server-side encryption with a customer-provided encryption key was
    # requested, the response will include this header confirming the
    # encryption algorithm used.
    # @return [String]
    def sse_customer_algorithm
      data[:sse_customer_algorithm]
    end

    # If server-side encryption with a customer-provided encryption key was
    # requested, the response will include this header to provide round-trip
    # message integrity verification of the customer-provided encryption
    # key.
    # @return [String]
    def sse_customer_key_md5
      data[:sse_customer_key_md5]
    end

    # If present, specifies the ID of the AWS Key Management Service (AWS
    # KMS) symmetric customer managed customer master key (CMK) that was
    # used for the object.
    # @return [String]
    def ssekms_key_id
      data[:ssekms_key_id]
    end

    # Provides storage class information of the object. Amazon S3 returns
    # this header for all objects except for S3 Standard storage class
    # objects.
    #
    # For more information, see [Storage Classes][1].
    #
    #
    #
    # [1]: https://docs.aws.amazon.com/AmazonS3/latest/dev/storage-class-intro.html
    # @return [String]
    def storage_class
      data[:storage_class]
    end

    # If present, indicates that the requester was successfully charged for
    # the request.
    # @return [String]
    def request_charged
      data[:request_charged]
    end

    # Amazon S3 can return this header if your request involves a bucket
    # that is either a source or destination in a replication rule.
    #
    # In replication, you have a source bucket on which you configure
    # replication and destination bucket where Amazon S3 stores object
    # replicas. When you request an object (`GetObject`) or object metadata
    # (`HeadObject`) from these buckets, Amazon S3 will return the
    # `x-amz-replication-status` header in the response as follows:
    #
    # * If requesting an object from the source bucket — Amazon S3 will
    #   return the `x-amz-replication-status` header if the object in your
    #   request is eligible for replication.
    #
    #   For example, suppose that in your replication configuration, you
    #   specify object prefix `TaxDocs` requesting Amazon S3 to replicate
    #   objects with key prefix `TaxDocs`. Any objects you upload with this
    #   key name prefix, for example `TaxDocs/document1.pdf`, are eligible
    #   for replication. For any object request with this key name prefix,
    #   Amazon S3 will return the `x-amz-replication-status` header with
    #   value PENDING, COMPLETED or FAILED indicating object replication
    #   status.
    #
    # * If requesting an object from the destination bucket — Amazon S3 will
    #   return the `x-amz-replication-status` header with value REPLICA if
    #   the object in your request is a replica that Amazon S3 created.
    #
    # For more information, see [Replication][1].
    #
    #
    #
    # [1]: https://docs.aws.amazon.com/AmazonS3/latest/dev/NotificationHowTo.html
    # @return [String]
    def replication_status
      data[:replication_status]
    end

    # The count of parts this object has.
    # @return [Integer]
    def parts_count
      data[:parts_count]
    end

    # The Object Lock mode, if any, that's in effect for this object. This
    # header is only returned if the requester has the
    # `s3:GetObjectRetention` permission. For more information about S3
    # Object Lock, see [Object Lock][1].
    #
    #
    #
    # [1]: https://docs.aws.amazon.com/AmazonS3/latest/dev/object-lock.html
    # @return [String]
    def object_lock_mode
      data[:object_lock_mode]
    end

    # The date and time when the Object Lock retention period expires. This
    # header is only returned if the requester has the
    # `s3:GetObjectRetention` permission.
    # @return [Time]
    def object_lock_retain_until_date
      data[:object_lock_retain_until_date]
    end

    # Specifies whether a legal hold is in effect for this object. This
    # header is only returned if the requester has the
    # `s3:GetObjectLegalHold` permission. This header is not returned if the
    # specified version of this object has never had a legal hold applied.
    # For more information about S3 Object Lock, see [Object Lock][1].
    #
    #
    #
    # [1]: https://docs.aws.amazon.com/AmazonS3/latest/dev/object-lock.html
    # @return [String]
    def object_lock_legal_hold_status
      data[:object_lock_legal_hold_status]
    end

    # @!endgroup

    # @return [Client]
    def client
      @client
    end

    # Loads, or reloads {#data} for the current {Object}.
    # Returns `self` making it possible to chain methods.
    #
    #     object.reload.data
    #
    # @return [self]
    def load
      resp = @client.head_object(
        bucket: @bucket_name,
        key: @key
      )
      @data = resp.data
      self
    end
    alias :reload :load

    # @return [Types::HeadObjectOutput]
    #   Returns the data for this {Object}. Calls
    #   {Client#head_object} if {#data_loaded?} is `false`.
    def data
      load unless @data
      @data
    end

    # @return [Boolean]
    #   Returns `true` if this resource is loaded.  Accessing attributes or
    #   {#data} on an unloaded resource will trigger a call to {#load}.
    def data_loaded?
      !!@data
    end

    # @param [Hash] options ({})
    # @return [Boolean]
    #   Returns `true` if the Object exists.
    def exists?(options = {})
      begin
        wait_until_exists(options.merge(max_attempts: 1))
        true
      rescue Aws::Waiters::Errors::UnexpectedError => e
        raise e.error
      rescue Aws::Waiters::Errors::WaiterFailed
        false
      end
    end

    # @param [Hash] options ({})
    # @option options [Integer] :max_attempts (20)
    # @option options [Float] :delay (5)
    # @option options [Proc] :before_attempt
    # @option options [Proc] :before_wait
    # @return [Object]
    def wait_until_exists(options = {}, &block)
      options, params = separate_params_and_options(options)
      waiter = Waiters::ObjectExists.new(options)
      yield_waiter_and_warn(waiter, &block) if block_given?
      waiter.wait(params.merge(bucket: @bucket_name,
        key: @key))
      Object.new({
        bucket_name: @bucket_name,
        key: @key,
        client: @client
      })
    end

    # @param [Hash] options ({})
    # @option options [Integer] :max_attempts (20)
    # @option options [Float] :delay (5)
    # @option options [Proc] :before_attempt
    # @option options [Proc] :before_wait
    # @return [Object]
    def wait_until_not_exists(options = {}, &block)
      options, params = separate_params_and_options(options)
      waiter = Waiters::ObjectNotExists.new(options)
      yield_waiter_and_warn(waiter, &block) if block_given?
      waiter.wait(params.merge(bucket: @bucket_name,
        key: @key))
      Object.new({
        bucket_name: @bucket_name,
        key: @key,
        client: @client
      })
    end

    # @deprecated Use [Aws::S3::Client] #wait_until instead
    #
    # Waiter polls an API operation until a resource enters a desired
    # state.
    #
    # @note The waiting operation is performed on a copy. The original resource
    #   remains unchanged.
    #
    # ## Basic Usage
    #
    # Waiter will polls until it is successful, it fails by
    # entering a terminal state, or until a maximum number of attempts
    # are made.
    #
    #     # polls in a loop until condition is true
    #     resource.wait_until(options) {|resource| condition}
    #
    # ## Example
    #
    #     instance.wait_until(max_attempts:10, delay:5) do |instance|
    #       instance.state.name == 'running'
    #     end
    #
    # ## Configuration
    #
    # You can configure the maximum number of polling attempts, and the
    # delay (in seconds) between each polling attempt. The waiting condition is
    # set by passing a block to {#wait_until}:
    #
    #     # poll for ~25 seconds
    #     resource.wait_until(max_attempts:5,delay:5) {|resource|...}
    #
    # ## Callbacks
    #
    # You can be notified before each polling attempt and before each
    # delay. If you throw `:success` or `:failure` from these callbacks,
    # it will terminate the waiter.
    #
    #     started_at = Time.now
    #     # poll for 1 hour, instead of a number of attempts
    #     proc = Proc.new do |attempts, response|
    #       throw :failure if Time.now - started_at > 3600
    #     end
    #
    #       # disable max attempts
    #     instance.wait_until(before_wait:proc, max_attempts:nil) {...}
    #
    # ## Handling Errors
    #
    # When a waiter is successful, it returns the Resource. When a waiter
    # fails, it raises an error.
    #
    #     begin
    #       resource.wait_until(...)
    #     rescue Aws::Waiters::Errors::WaiterFailed
    #       # resource did not enter the desired state in time
    #     end
    #
    # @yieldparam [Resource] resource to be used in the waiting condition.
    #
    # @raise [Aws::Waiters::Errors::FailureStateError] Raised when the waiter
    #   terminates because the waiter has entered a state that it will not
    #   transition out of, preventing success.
    #
    #   yet successful.
    #
    # @raise [Aws::Waiters::Errors::UnexpectedError] Raised when an error is
    #   encountered while polling for a resource that is not expected.
    #
    # @raise [NotImplementedError] Raised when the resource does not
    #
    # @option options [Integer] :max_attempts (10) Maximum number of
    # attempts
    # @option options [Integer] :delay (10) Delay between each
    # attempt in seconds
    # @option options [Proc] :before_attempt (nil) Callback
    # invoked before each attempt
    # @option options [Proc] :before_wait (nil) Callback
    # invoked before each wait
    # @return [Resource] if the waiter was successful
    def wait_until(options = {}, &block)
      self_copy = self.dup
      attempts = 0
      options[:max_attempts] = 10 unless options.key?(:max_attempts)
      options[:delay] ||= 10
      options[:poller] = Proc.new do
        attempts += 1
        if block.call(self_copy)
          [:success, self_copy]
        else
          self_copy.reload unless attempts == options[:max_attempts]
          :retry
        end
      end
      Aws::Waiters::Waiter.new(options).wait({})
    end

    # @!group Actions

    # @example Request syntax with placeholder values
    #
    #   object.copy_from({
    #     acl: "private", # accepts private, public-read, public-read-write, authenticated-read, aws-exec-read, bucket-owner-read, bucket-owner-full-control
    #     cache_control: "CacheControl",
    #     content_disposition: "ContentDisposition",
    #     content_encoding: "ContentEncoding",
    #     content_language: "ContentLanguage",
    #     content_type: "ContentType",
    #     copy_source: "CopySource", # required
    #     copy_source_if_match: "CopySourceIfMatch",
    #     copy_source_if_modified_since: Time.now,
    #     copy_source_if_none_match: "CopySourceIfNoneMatch",
    #     copy_source_if_unmodified_since: Time.now,
    #     expires: Time.now,
    #     grant_full_control: "GrantFullControl",
    #     grant_read: "GrantRead",
    #     grant_read_acp: "GrantReadACP",
    #     grant_write_acp: "GrantWriteACP",
    #     metadata: {
    #       "MetadataKey" => "MetadataValue",
    #     },
    #     metadata_directive: "COPY", # accepts COPY, REPLACE
    #     tagging_directive: "COPY", # accepts COPY, REPLACE
    #     server_side_encryption: "AES256", # accepts AES256, aws:kms
    #     storage_class: "STANDARD", # accepts STANDARD, REDUCED_REDUNDANCY, STANDARD_IA, ONEZONE_IA, INTELLIGENT_TIERING, GLACIER, DEEP_ARCHIVE
    #     website_redirect_location: "WebsiteRedirectLocation",
    #     sse_customer_algorithm: "SSECustomerAlgorithm",
    #     sse_customer_key: "SSECustomerKey",
    #     sse_customer_key_md5: "SSECustomerKeyMD5",
    #     ssekms_key_id: "SSEKMSKeyId",
    #     ssekms_encryption_context: "SSEKMSEncryptionContext",
    #     copy_source_sse_customer_algorithm: "CopySourceSSECustomerAlgorithm",
    #     copy_source_sse_customer_key: "CopySourceSSECustomerKey",
    #     copy_source_sse_customer_key_md5: "CopySourceSSECustomerKeyMD5",
    #     request_payer: "requester", # accepts requester
    #     tagging: "TaggingHeader",
    #     object_lock_mode: "GOVERNANCE", # accepts GOVERNANCE, COMPLIANCE
    #     object_lock_retain_until_date: Time.now,
    #     object_lock_legal_hold_status: "ON", # accepts ON, OFF
    #   })
    # @param [Hash] options ({})
    # @option options [String] :acl
    #   The canned ACL to apply to the object.
    # @option options [String] :cache_control
    #   Specifies caching behavior along the request/reply chain.
    # @option options [String] :content_disposition
    #   Specifies presentational information for the object.
    # @option options [String] :content_encoding
    #   Specifies what content encodings have been applied to the object and
    #   thus what decoding mechanisms must be applied to obtain the media-type
    #   referenced by the Content-Type header field.
    # @option options [String] :content_language
    #   The language the content is in.
    # @option options [String] :content_type
    #   A standard MIME type describing the format of the object data.
    # @option options [required, String] :copy_source
    #   The name of the source bucket and key name of the source object,
    #   separated by a slash (/). Must be URL-encoded.
    # @option options [String] :copy_source_if_match
    #   Copies the object if its entity tag (ETag) matches the specified tag.
    # @option options [Time,DateTime,Date,Integer,String] :copy_source_if_modified_since
    #   Copies the object if it has been modified since the specified time.
    # @option options [String] :copy_source_if_none_match
    #   Copies the object if its entity tag (ETag) is different than the
    #   specified ETag.
    # @option options [Time,DateTime,Date,Integer,String] :copy_source_if_unmodified_since
    #   Copies the object if it hasn't been modified since the specified
    #   time.
    # @option options [Time,DateTime,Date,Integer,String] :expires
    #   The date and time at which the object is no longer cacheable.
    # @option options [String] :grant_full_control
    #   Gives the grantee READ, READ\_ACP, and WRITE\_ACP permissions on the
    #   object.
    # @option options [String] :grant_read
    #   Allows grantee to read the object data and its metadata.
    # @option options [String] :grant_read_acp
    #   Allows grantee to read the object ACL.
    # @option options [String] :grant_write_acp
    #   Allows grantee to write the ACL for the applicable object.
    # @option options [Hash<String,String>] :metadata
    #   A map of metadata to store with the object in S3.
    # @option options [String] :metadata_directive
    #   Specifies whether the metadata is copied from the source object or
    #   replaced with metadata provided in the request.
    # @option options [String] :tagging_directive
    #   Specifies whether the object tag-set are copied from the source object
    #   or replaced with tag-set provided in the request.
    # @option options [String] :server_side_encryption
    #   The server-side encryption algorithm used when storing this object in
    #   Amazon S3 (for example, AES256, aws:kms).
    # @option options [String] :storage_class
    #   The type of storage to use for the object. Defaults to 'STANDARD'.
    # @option options [String] :website_redirect_location
    #   If the bucket is configured as a website, redirects requests for this
    #   object to another object in the same bucket or to an external URL.
    #   Amazon S3 stores the value of this header in the object metadata.
    # @option options [String] :sse_customer_algorithm
    #   Specifies the algorithm to use to when encrypting the object (for
    #   example, AES256).
    # @option options [String] :sse_customer_key
    #   Specifies the customer-provided encryption key for Amazon S3 to use in
    #   encrypting data. This value is used to store the object and then it is
    #   discarded; Amazon S3 does not store the encryption key. The key must
    #   be appropriate for use with the algorithm specified in the
    #   `x-amz-server-side​-encryption​-customer-algorithm` header.
    # @option options [String] :sse_customer_key_md5
    #   Specifies the 128-bit MD5 digest of the encryption key according to
    #   RFC 1321. Amazon S3 uses this header for a message integrity check to
    #   ensure that the encryption key was transmitted without error.
    # @option options [String] :ssekms_key_id
    #   Specifies the AWS KMS key ID to use for object encryption. All GET and
    #   PUT requests for an object protected by AWS KMS will fail if not made
    #   via SSL or using SigV4. For information about configuring using any of
    #   the officially supported AWS SDKs and AWS CLI, see [Specifying the
    #   Signature Version in Request Authentication][1] in the *Amazon S3
    #   Developer Guide*.
    #
    #
    #
    #   [1]: https://docs.aws.amazon.com/AmazonS3/latest/dev/UsingAWSSDK.html#specify-signature-version
    # @option options [String] :ssekms_encryption_context
    #   Specifies the AWS KMS Encryption Context to use for object encryption.
    #   The value of this header is a base64-encoded UTF-8 string holding JSON
    #   with the encryption context key-value pairs.
    # @option options [String] :copy_source_sse_customer_algorithm
    #   Specifies the algorithm to use when decrypting the source object (for
    #   example, AES256).
    # @option options [String] :copy_source_sse_customer_key
    #   Specifies the customer-provided encryption key for Amazon S3 to use to
    #   decrypt the source object. The encryption key provided in this header
    #   must be one that was used when the source object was created.
    # @option options [String] :copy_source_sse_customer_key_md5
    #   Specifies the 128-bit MD5 digest of the encryption key according to
    #   RFC 1321. Amazon S3 uses this header for a message integrity check to
    #   ensure that the encryption key was transmitted without error.
    # @option options [String] :request_payer
    #   Confirms that the requester knows that they will be charged for the
    #   request. Bucket owners need not specify this parameter in their
    #   requests. For information about downloading objects from requester
    #   pays buckets, see [Downloading Objects in Requestor Pays Buckets][1]
    #   in the *Amazon S3 Developer Guide*.
    #
    #
    #
    #   [1]: https://docs.aws.amazon.com/AmazonS3/latest/dev/ObjectsinRequesterPaysBuckets.html
    # @option options [String] :tagging
    #   The tag-set for the object destination object this value must be used
    #   in conjunction with the `TaggingDirective`. The tag-set must be
    #   encoded as URL Query parameters.
    # @option options [String] :object_lock_mode
    #   The Object Lock mode that you want to apply to the copied object.
    # @option options [Time,DateTime,Date,Integer,String] :object_lock_retain_until_date
    #   The date and time when you want the copied object's Object Lock to
    #   expire.
    # @option options [String] :object_lock_legal_hold_status
    #   Specifies whether you want to apply a Legal Hold to the copied object.
    # @return [Types::CopyObjectOutput]
    def copy_from(options = {})
      options = options.merge(
        bucket: @bucket_name,
        key: @key
      )
      resp = @client.copy_object(options)
      resp.data
    end

    # @example Request syntax with placeholder values
    #
    #   object.delete({
    #     mfa: "MFA",
    #     version_id: "ObjectVersionId",
    #     request_payer: "requester", # accepts requester
    #     bypass_governance_retention: false,
    #   })
    # @param [Hash] options ({})
    # @option options [String] :mfa
    #   The concatenation of the authentication device's serial number, a
    #   space, and the value that is displayed on your authentication device.
    #   Required to permanently delete a versioned object if versioning is
    #   configured with MFA delete enabled.
    # @option options [String] :version_id
    #   VersionId used to reference a specific version of the object.
    # @option options [String] :request_payer
    #   Confirms that the requester knows that they will be charged for the
    #   request. Bucket owners need not specify this parameter in their
    #   requests. For information about downloading objects from requester
    #   pays buckets, see [Downloading Objects in Requestor Pays Buckets][1]
    #   in the *Amazon S3 Developer Guide*.
    #
    #
    #
    #   [1]: https://docs.aws.amazon.com/AmazonS3/latest/dev/ObjectsinRequesterPaysBuckets.html
    # @option options [Boolean] :bypass_governance_retention
    #   Indicates whether S3 Object Lock should bypass Governance-mode
    #   restrictions to process this operation.
    # @return [Types::DeleteObjectOutput]
    def delete(options = {})
      options = options.merge(
        bucket: @bucket_name,
        key: @key
      )
      resp = @client.delete_object(options)
      resp.data
    end

    # @example Request syntax with placeholder values
    #
    #   object.get({
    #     if_match: "IfMatch",
    #     if_modified_since: Time.now,
    #     if_none_match: "IfNoneMatch",
    #     if_unmodified_since: Time.now,
    #     range: "Range",
    #     response_cache_control: "ResponseCacheControl",
    #     response_content_disposition: "ResponseContentDisposition",
    #     response_content_encoding: "ResponseContentEncoding",
    #     response_content_language: "ResponseContentLanguage",
    #     response_content_type: "ResponseContentType",
    #     response_expires: Time.now,
    #     version_id: "ObjectVersionId",
    #     sse_customer_algorithm: "SSECustomerAlgorithm",
    #     sse_customer_key: "SSECustomerKey",
    #     sse_customer_key_md5: "SSECustomerKeyMD5",
    #     request_payer: "requester", # accepts requester
    #     part_number: 1,
    #   })
    # @param [Hash] options ({})
    # @option options [String] :if_match
    #   Return the object only if its entity tag (ETag) is the same as the one
    #   specified, otherwise return a 412 (precondition failed).
    # @option options [Time,DateTime,Date,Integer,String] :if_modified_since
    #   Return the object only if it has been modified since the specified
    #   time, otherwise return a 304 (not modified).
    # @option options [String] :if_none_match
    #   Return the object only if its entity tag (ETag) is different from the
    #   one specified, otherwise return a 304 (not modified).
    # @option options [Time,DateTime,Date,Integer,String] :if_unmodified_since
    #   Return the object only if it has not been modified since the specified
    #   time, otherwise return a 412 (precondition failed).
    # @option options [String] :range
    #   Downloads the specified range bytes of an object. For more information
    #   about the HTTP Range header, see
    #   [https://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.35][1].
    #
    #   <note markdown="1"> Amazon S3 doesn't support retrieving multiple ranges of data per
    #   `GET` request.
    #
    #    </note>
    #
    #
    #
    #   [1]: https://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.35
    # @option options [String] :response_cache_control
    #   Sets the `Cache-Control` header of the response.
    # @option options [String] :response_content_disposition
    #   Sets the `Content-Disposition` header of the response
    # @option options [String] :response_content_encoding
    #   Sets the `Content-Encoding` header of the response.
    # @option options [String] :response_content_language
    #   Sets the `Content-Language` header of the response.
    # @option options [String] :response_content_type
    #   Sets the `Content-Type` header of the response.
    # @option options [Time,DateTime,Date,Integer,String] :response_expires
    #   Sets the `Expires` header of the response.
    # @option options [String] :version_id
    #   VersionId used to reference a specific version of the object.
    # @option options [String] :sse_customer_algorithm
    #   Specifies the algorithm to use to when encrypting the object (for
    #   example, AES256).
    # @option options [String] :sse_customer_key
    #   Specifies the customer-provided encryption key for Amazon S3 to use in
    #   encrypting data. This value is used to store the object and then it is
    #   discarded; Amazon S3 does not store the encryption key. The key must
    #   be appropriate for use with the algorithm specified in the
    #   `x-amz-server-side​-encryption​-customer-algorithm` header.
    # @option options [String] :sse_customer_key_md5
    #   Specifies the 128-bit MD5 digest of the encryption key according to
    #   RFC 1321. Amazon S3 uses this header for a message integrity check to
    #   ensure that the encryption key was transmitted without error.
    # @option options [String] :request_payer
    #   Confirms that the requester knows that they will be charged for the
    #   request. Bucket owners need not specify this parameter in their
    #   requests. For information about downloading objects from requester
    #   pays buckets, see [Downloading Objects in Requestor Pays Buckets][1]
    #   in the *Amazon S3 Developer Guide*.
    #
    #
    #
    #   [1]: https://docs.aws.amazon.com/AmazonS3/latest/dev/ObjectsinRequesterPaysBuckets.html
    # @option options [Integer] :part_number
    #   Part number of the object being read. This is a positive integer
    #   between 1 and 10,000. Effectively performs a 'ranged' GET request
    #   for the part specified. Useful for downloading just a part of an
    #   object.
    # @return [Types::GetObjectOutput]
    def get(options = {}, &block)
      options = options.merge(
        bucket: @bucket_name,
        key: @key
      )
      resp = @client.get_object(options, &block)
      resp.data
    end

    # @example Request syntax with placeholder values
    #
    #   multipartupload = object.initiate_multipart_upload({
    #     acl: "private", # accepts private, public-read, public-read-write, authenticated-read, aws-exec-read, bucket-owner-read, bucket-owner-full-control
    #     cache_control: "CacheControl",
    #     content_disposition: "ContentDisposition",
    #     content_encoding: "ContentEncoding",
    #     content_language: "ContentLanguage",
    #     content_type: "ContentType",
    #     expires: Time.now,
    #     grant_full_control: "GrantFullControl",
    #     grant_read: "GrantRead",
    #     grant_read_acp: "GrantReadACP",
    #     grant_write_acp: "GrantWriteACP",
    #     metadata: {
    #       "MetadataKey" => "MetadataValue",
    #     },
    #     server_side_encryption: "AES256", # accepts AES256, aws:kms
    #     storage_class: "STANDARD", # accepts STANDARD, REDUCED_REDUNDANCY, STANDARD_IA, ONEZONE_IA, INTELLIGENT_TIERING, GLACIER, DEEP_ARCHIVE
    #     website_redirect_location: "WebsiteRedirectLocation",
    #     sse_customer_algorithm: "SSECustomerAlgorithm",
    #     sse_customer_key: "SSECustomerKey",
    #     sse_customer_key_md5: "SSECustomerKeyMD5",
    #     ssekms_key_id: "SSEKMSKeyId",
    #     ssekms_encryption_context: "SSEKMSEncryptionContext",
    #     request_payer: "requester", # accepts requester
    #     tagging: "TaggingHeader",
    #     object_lock_mode: "GOVERNANCE", # accepts GOVERNANCE, COMPLIANCE
    #     object_lock_retain_until_date: Time.now,
    #     object_lock_legal_hold_status: "ON", # accepts ON, OFF
    #   })
    # @param [Hash] options ({})
    # @option options [String] :acl
    #   The canned ACL to apply to the object.
    # @option options [String] :cache_control
    #   Specifies caching behavior along the request/reply chain.
    # @option options [String] :content_disposition
    #   Specifies presentational information for the object.
    # @option options [String] :content_encoding
    #   Specifies what content encodings have been applied to the object and
    #   thus what decoding mechanisms must be applied to obtain the media-type
    #   referenced by the Content-Type header field.
    # @option options [String] :content_language
    #   The language the content is in.
    # @option options [String] :content_type
    #   A standard MIME type describing the format of the object data.
    # @option options [Time,DateTime,Date,Integer,String] :expires
    #   The date and time at which the object is no longer cacheable.
    # @option options [String] :grant_full_control
    #   Gives the grantee READ, READ\_ACP, and WRITE\_ACP permissions on the
    #   object.
    # @option options [String] :grant_read
    #   Allows grantee to read the object data and its metadata.
    # @option options [String] :grant_read_acp
    #   Allows grantee to read the object ACL.
    # @option options [String] :grant_write_acp
    #   Allows grantee to write the ACL for the applicable object.
    # @option options [Hash<String,String>] :metadata
    #   A map of metadata to store with the object in S3.
    # @option options [String] :server_side_encryption
    #   The server-side encryption algorithm used when storing this object in
    #   Amazon S3 (for example, AES256, aws:kms).
    # @option options [String] :storage_class
    #   The type of storage to use for the object. Defaults to 'STANDARD'.
    # @option options [String] :website_redirect_location
    #   If the bucket is configured as a website, redirects requests for this
    #   object to another object in the same bucket or to an external URL.
    #   Amazon S3 stores the value of this header in the object metadata.
    # @option options [String] :sse_customer_algorithm
    #   Specifies the algorithm to use to when encrypting the object (for
    #   example, AES256).
    # @option options [String] :sse_customer_key
    #   Specifies the customer-provided encryption key for Amazon S3 to use in
    #   encrypting data. This value is used to store the object and then it is
    #   discarded; Amazon S3 does not store the encryption key. The key must
    #   be appropriate for use with the algorithm specified in the
    #   `x-amz-server-side​-encryption​-customer-algorithm` header.
    # @option options [String] :sse_customer_key_md5
    #   Specifies the 128-bit MD5 digest of the encryption key according to
    #   RFC 1321. Amazon S3 uses this header for a message integrity check to
    #   ensure that the encryption key was transmitted without error.
    # @option options [String] :ssekms_key_id
    #   Specifies the ID of the symmetric customer managed AWS KMS CMK to use
    #   for object encryption. All GET and PUT requests for an object
    #   protected by AWS KMS will fail if not made via SSL or using SigV4. For
    #   information about configuring using any of the officially supported
    #   AWS SDKs and AWS CLI, see [Specifying the Signature Version in Request
    #   Authentication][1] in the *Amazon S3 Developer Guide*.
    #
    #
    #
    #   [1]: https://docs.aws.amazon.com/http:/docs.aws.amazon.com/AmazonS3/latest/dev/UsingAWSSDK.html#specify-signature-version
    # @option options [String] :ssekms_encryption_context
    #   Specifies the AWS KMS Encryption Context to use for object encryption.
    #   The value of this header is a base64-encoded UTF-8 string holding JSON
    #   with the encryption context key-value pairs.
    # @option options [String] :request_payer
    #   Confirms that the requester knows that they will be charged for the
    #   request. Bucket owners need not specify this parameter in their
    #   requests. For information about downloading objects from requester
    #   pays buckets, see [Downloading Objects in Requestor Pays Buckets][1]
    #   in the *Amazon S3 Developer Guide*.
    #
    #
    #
    #   [1]: https://docs.aws.amazon.com/AmazonS3/latest/dev/ObjectsinRequesterPaysBuckets.html
    # @option options [String] :tagging
    #   The tag-set for the object. The tag-set must be encoded as URL Query
    #   parameters.
    # @option options [String] :object_lock_mode
    #   Specifies the Object Lock mode that you want to apply to the uploaded
    #   object.
    # @option options [Time,DateTime,Date,Integer,String] :object_lock_retain_until_date
    #   Specifies the date and time when you want the Object Lock to expire.
    # @option options [String] :object_lock_legal_hold_status
    #   Specifies whether you want to apply a Legal Hold to the uploaded
    #   object.
    # @return [MultipartUpload]
    def initiate_multipart_upload(options = {})
      options = options.merge(
        bucket: @bucket_name,
        key: @key
      )
      resp = @client.create_multipart_upload(options)
      MultipartUpload.new(
        bucket_name: @bucket_name,
        object_key: @key,
        id: resp.data.upload_id,
        client: @client
      )
    end

    # @example Request syntax with placeholder values
    #
    #   object.put({
    #     acl: "private", # accepts private, public-read, public-read-write, authenticated-read, aws-exec-read, bucket-owner-read, bucket-owner-full-control
    #     body: source_file,
    #     cache_control: "CacheControl",
    #     content_disposition: "ContentDisposition",
    #     content_encoding: "ContentEncoding",
    #     content_language: "ContentLanguage",
    #     content_length: 1,
    #     content_md5: "ContentMD5",
    #     content_type: "ContentType",
    #     expires: Time.now,
    #     grant_full_control: "GrantFullControl",
    #     grant_read: "GrantRead",
    #     grant_read_acp: "GrantReadACP",
    #     grant_write_acp: "GrantWriteACP",
    #     metadata: {
    #       "MetadataKey" => "MetadataValue",
    #     },
    #     server_side_encryption: "AES256", # accepts AES256, aws:kms
    #     storage_class: "STANDARD", # accepts STANDARD, REDUCED_REDUNDANCY, STANDARD_IA, ONEZONE_IA, INTELLIGENT_TIERING, GLACIER, DEEP_ARCHIVE
    #     website_redirect_location: "WebsiteRedirectLocation",
    #     sse_customer_algorithm: "SSECustomerAlgorithm",
    #     sse_customer_key: "SSECustomerKey",
    #     sse_customer_key_md5: "SSECustomerKeyMD5",
    #     ssekms_key_id: "SSEKMSKeyId",
    #     ssekms_encryption_context: "SSEKMSEncryptionContext",
    #     request_payer: "requester", # accepts requester
    #     tagging: "TaggingHeader",
    #     object_lock_mode: "GOVERNANCE", # accepts GOVERNANCE, COMPLIANCE
    #     object_lock_retain_until_date: Time.now,
    #     object_lock_legal_hold_status: "ON", # accepts ON, OFF
    #   })
    # @param [Hash] options ({})
    # @option options [String] :acl
    #   The canned ACL to apply to the object. For more information, see
    #   [Canned ACL][1].
    #
    #
    #
    #   [1]: https://docs.aws.amazon.com/AmazonS3/latest/dev/acl-overview.html#CannedACL
    # @option options [String, StringIO, File] :body
    #   Object data.
    # @option options [String] :cache_control
    #   Can be used to specify caching behavior along the request/reply chain.
    #   For more information, see
    #   [http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.9][1].
    #
    #
    #
    #   [1]: http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.9
    # @option options [String] :content_disposition
    #   Specifies presentational information for the object. For more
    #   information, see
    #   [http://www.w3.org/Protocols/rfc2616/rfc2616-sec19.html#sec19.5.1][1].
    #
    #
    #
    #   [1]: http://www.w3.org/Protocols/rfc2616/rfc2616-sec19.html#sec19.5.1
    # @option options [String] :content_encoding
    #   Specifies what content encodings have been applied to the object and
    #   thus what decoding mechanisms must be applied to obtain the media-type
    #   referenced by the Content-Type header field. For more information, see
    #   [http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.11][1].
    #
    #
    #
    #   [1]: http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.11
    # @option options [String] :content_language
    #   The language the content is in.
    # @option options [Integer] :content_length
    #   Size of the body in bytes. This parameter is useful when the size of
    #   the body cannot be determined automatically. For more information, see
    #   [http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.13][1].
    #
    #
    #
    #   [1]: http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.13
    # @option options [String] :content_md5
    #   The base64-encoded 128-bit MD5 digest of the message (without the
    #   headers) according to RFC 1864. This header can be used as a message
    #   integrity check to verify that the data is the same data that was
    #   originally sent. Although it is optional, we recommend using the
    #   Content-MD5 mechanism as an end-to-end integrity check. For more
    #   information about REST request authentication, see [REST
    #   Authentication][1].
    #
    #
    #
    #   [1]: https://docs.aws.amazon.com/AmazonS3/latest/dev/RESTAuthentication.html
    # @option options [String] :content_type
    #   A standard MIME type describing the format of the contents. For more
    #   information, see
    #   [http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.17][1].
    #
    #
    #
    #   [1]: http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.17
    # @option options [Time,DateTime,Date,Integer,String] :expires
    #   The date and time at which the object is no longer cacheable. For more
    #   information, see
    #   [http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.21][1].
    #
    #
    #
    #   [1]: http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.21
    # @option options [String] :grant_full_control
    #   Gives the grantee READ, READ\_ACP, and WRITE\_ACP permissions on the
    #   object.
    # @option options [String] :grant_read
    #   Allows grantee to read the object data and its metadata.
    # @option options [String] :grant_read_acp
    #   Allows grantee to read the object ACL.
    # @option options [String] :grant_write_acp
    #   Allows grantee to write the ACL for the applicable object.
    # @option options [Hash<String,String>] :metadata
    #   A map of metadata to store with the object in S3.
    # @option options [String] :server_side_encryption
    #   The server-side encryption algorithm used when storing this object in
    #   Amazon S3 (for example, AES256, aws:kms).
    # @option options [String] :storage_class
    #   If you don't specify, S3 Standard is the default storage class.
    #   Amazon S3 supports other storage classes.
    # @option options [String] :website_redirect_location
    #   If the bucket is configured as a website, redirects requests for this
    #   object to another object in the same bucket or to an external URL.
    #   Amazon S3 stores the value of this header in the object metadata. For
    #   information about object metadata, see [Object Key and Metadata][1].
    #
    #   In the following example, the request header sets the redirect to an
    #   object (anotherPage.html) in the same bucket:
    #
    #   `x-amz-website-redirect-location: /anotherPage.html`
    #
    #   In the following example, the request header sets the object redirect
    #   to another website:
    #
    #   `x-amz-website-redirect-location: http://www.example.com/`
    #
    #   For more information about website hosting in Amazon S3, see [Hosting
    #   Websites on Amazon S3][2] and [How to Configure Website Page
    #   Redirects][3].
    #
    #
    #
    #   [1]: https://docs.aws.amazon.com/AmazonS3/latest/dev/UsingMetadata.html
    #   [2]: https://docs.aws.amazon.com/AmazonS3/latest/dev/WebsiteHosting.html
    #   [3]: https://docs.aws.amazon.com/AmazonS3/latest/dev/how-to-page-redirect.html
    # @option options [String] :sse_customer_algorithm
    #   Specifies the algorithm to use to when encrypting the object (for
    #   example, AES256).
    # @option options [String] :sse_customer_key
    #   Specifies the customer-provided encryption key for Amazon S3 to use in
    #   encrypting data. This value is used to store the object and then it is
    #   discarded; Amazon S3 does not store the encryption key. The key must
    #   be appropriate for use with the algorithm specified in the
    #   `x-amz-server-side​-encryption​-customer-algorithm` header.
    # @option options [String] :sse_customer_key_md5
    #   Specifies the 128-bit MD5 digest of the encryption key according to
    #   RFC 1321. Amazon S3 uses this header for a message integrity check to
    #   ensure that the encryption key was transmitted without error.
    # @option options [String] :ssekms_key_id
    #   If `x-amz-server-side-encryption` is present and has the value of
    #   `aws:kms`, this header specifies the ID of the AWS Key Management
    #   Service (AWS KMS) symmetrical customer managed customer master key
    #   (CMK) that was used for the object.
    #
    #   If the value of `x-amz-server-side-encryption` is `aws:kms`, this
    #   header specifies the ID of the symmetric customer managed AWS KMS CMK
    #   that will be used for the object. If you specify
    #   `x-amz-server-side-encryption:aws:kms`, but do not provide`
    #   x-amz-server-side-encryption-aws-kms-key-id`, Amazon S3 uses the AWS
    #   managed CMK in AWS to protect the data.
    # @option options [String] :ssekms_encryption_context
    #   Specifies the AWS KMS Encryption Context to use for object encryption.
    #   The value of this header is a base64-encoded UTF-8 string holding JSON
    #   with the encryption context key-value pairs.
    # @option options [String] :request_payer
    #   Confirms that the requester knows that they will be charged for the
    #   request. Bucket owners need not specify this parameter in their
    #   requests. For information about downloading objects from requester
    #   pays buckets, see [Downloading Objects in Requestor Pays Buckets][1]
    #   in the *Amazon S3 Developer Guide*.
    #
    #
    #
    #   [1]: https://docs.aws.amazon.com/AmazonS3/latest/dev/ObjectsinRequesterPaysBuckets.html
    # @option options [String] :tagging
    #   The tag-set for the object. The tag-set must be encoded as URL Query
    #   parameters. (For example, "Key1=Value1")
    # @option options [String] :object_lock_mode
    #   The Object Lock mode that you want to apply to this object.
    # @option options [Time,DateTime,Date,Integer,String] :object_lock_retain_until_date
    #   The date and time when you want this object's Object Lock to expire.
    # @option options [String] :object_lock_legal_hold_status
    #   Specifies whether a legal hold will be applied to this object. For
    #   more information about S3 Object Lock, see [Object Lock][1].
    #
    #
    #
    #   [1]: https://docs.aws.amazon.com/AmazonS3/latest/dev/object-lock.html
    # @return [Types::PutObjectOutput]
    def put(options = {})
      options = options.merge(
        bucket: @bucket_name,
        key: @key
      )
      resp = @client.put_object(options)
      resp.data
    end

    # @example Request syntax with placeholder values
    #
    #   object.restore_object({
    #     version_id: "ObjectVersionId",
    #     restore_request: {
    #       days: 1,
    #       glacier_job_parameters: {
    #         tier: "Standard", # required, accepts Standard, Bulk, Expedited
    #       },
    #       type: "SELECT", # accepts SELECT
    #       tier: "Standard", # accepts Standard, Bulk, Expedited
    #       description: "Description",
    #       select_parameters: {
    #         input_serialization: { # required
    #           csv: {
    #             file_header_info: "USE", # accepts USE, IGNORE, NONE
    #             comments: "Comments",
    #             quote_escape_character: "QuoteEscapeCharacter",
    #             record_delimiter: "RecordDelimiter",
    #             field_delimiter: "FieldDelimiter",
    #             quote_character: "QuoteCharacter",
    #             allow_quoted_record_delimiter: false,
    #           },
    #           compression_type: "NONE", # accepts NONE, GZIP, BZIP2
    #           json: {
    #             type: "DOCUMENT", # accepts DOCUMENT, LINES
    #           },
    #           parquet: {
    #           },
    #         },
    #         expression_type: "SQL", # required, accepts SQL
    #         expression: "Expression", # required
    #         output_serialization: { # required
    #           csv: {
    #             quote_fields: "ALWAYS", # accepts ALWAYS, ASNEEDED
    #             quote_escape_character: "QuoteEscapeCharacter",
    #             record_delimiter: "RecordDelimiter",
    #             field_delimiter: "FieldDelimiter",
    #             quote_character: "QuoteCharacter",
    #           },
    #           json: {
    #             record_delimiter: "RecordDelimiter",
    #           },
    #         },
    #       },
    #       output_location: {
    #         s3: {
    #           bucket_name: "BucketName", # required
    #           prefix: "LocationPrefix", # required
    #           encryption: {
    #             encryption_type: "AES256", # required, accepts AES256, aws:kms
    #             kms_key_id: "SSEKMSKeyId",
    #             kms_context: "KMSContext",
    #           },
    #           canned_acl: "private", # accepts private, public-read, public-read-write, authenticated-read, aws-exec-read, bucket-owner-read, bucket-owner-full-control
    #           access_control_list: [
    #             {
    #               grantee: {
    #                 display_name: "DisplayName",
    #                 email_address: "EmailAddress",
    #                 id: "ID",
    #                 type: "CanonicalUser", # required, accepts CanonicalUser, AmazonCustomerByEmail, Group
    #                 uri: "URI",
    #               },
    #               permission: "FULL_CONTROL", # accepts FULL_CONTROL, WRITE, WRITE_ACP, READ, READ_ACP
    #             },
    #           ],
    #           tagging: {
    #             tag_set: [ # required
    #               {
    #                 key: "ObjectKey", # required
    #                 value: "Value", # required
    #               },
    #             ],
    #           },
    #           user_metadata: [
    #             {
    #               name: "MetadataKey",
    #               value: "MetadataValue",
    #             },
    #           ],
    #           storage_class: "STANDARD", # accepts STANDARD, REDUCED_REDUNDANCY, STANDARD_IA, ONEZONE_IA, INTELLIGENT_TIERING, GLACIER, DEEP_ARCHIVE
    #         },
    #       },
    #     },
    #     request_payer: "requester", # accepts requester
    #   })
    # @param [Hash] options ({})
    # @option options [String] :version_id
    #   VersionId used to reference a specific version of the object.
    # @option options [Types::RestoreRequest] :restore_request
    #   Container for restore job parameters.
    # @option options [String] :request_payer
    #   Confirms that the requester knows that they will be charged for the
    #   request. Bucket owners need not specify this parameter in their
    #   requests. For information about downloading objects from requester
    #   pays buckets, see [Downloading Objects in Requestor Pays Buckets][1]
    #   in the *Amazon S3 Developer Guide*.
    #
    #
    #
    #   [1]: https://docs.aws.amazon.com/AmazonS3/latest/dev/ObjectsinRequesterPaysBuckets.html
    # @return [Types::RestoreObjectOutput]
    def restore_object(options = {})
      options = options.merge(
        bucket: @bucket_name,
        key: @key
      )
      resp = @client.restore_object(options)
      resp.data
    end

    # @!group Associations

    # @return [ObjectAcl]
    def acl
      ObjectAcl.new(
        bucket_name: @bucket_name,
        object_key: @key,
        client: @client
      )
    end

    # @return [Bucket]
    def bucket
      Bucket.new(
        name: @bucket_name,
        client: @client
      )
    end

    # @param [String] id
    # @return [MultipartUpload]
    def multipart_upload(id)
      MultipartUpload.new(
        bucket_name: @bucket_name,
        object_key: @key,
        id: id,
        client: @client
      )
    end

    # @param [String] id
    # @return [ObjectVersion]
    def version(id)
      ObjectVersion.new(
        bucket_name: @bucket_name,
        object_key: @key,
        id: id,
        client: @client
      )
    end

    # @deprecated
    # @api private
    def identifiers
      {
        bucket_name: @bucket_name,
        key: @key
      }
    end
    deprecated(:identifiers)

    private

    def extract_bucket_name(args, options)
      value = args[0] || options.delete(:bucket_name)
      case value
      when String then value
      when nil then raise ArgumentError, "missing required option :bucket_name"
      else
        msg = "expected :bucket_name to be a String, got #{value.class}"
        raise ArgumentError, msg
      end
    end

    def extract_key(args, options)
      value = args[1] || options.delete(:key)
      case value
      when String then value
      when nil then raise ArgumentError, "missing required option :key"
      else
        msg = "expected :key to be a String, got #{value.class}"
        raise ArgumentError, msg
      end
    end

    def yield_waiter_and_warn(waiter, &block)
      if !@waiter_block_warned
        msg = "pass options to configure the waiter; "\
              "yielding the waiter is deprecated"
        warn(msg)
        @waiter_block_warned = true
      end
      yield(waiter.waiter)
    end

    def separate_params_and_options(options)
      opts = Set.new(
        [:client, :max_attempts, :delay, :before_attempt, :before_wait]
      )
      waiter_opts = {}
      waiter_params = {}
      options.each_pair do |key, value|
        if opts.include?(key)
          waiter_opts[key] = value
        else
          waiter_params[key] = value
        end
      end
      waiter_opts[:client] ||= @client
      [waiter_opts, waiter_params]
    end

    class Collection < Aws::Resources::Collection

      # @!group Batch Actions

      # @example Request syntax with placeholder values
      #
      #   object.batch_delete!({
      #     mfa: "MFA",
      #     request_payer: "requester", # accepts requester
      #     bypass_governance_retention: false,
      #   })
      # @param options ({})
      # @option options [String] :mfa
      #   The concatenation of the authentication device's serial number, a
      #   space, and the value that is displayed on your authentication device.
      #   Required to permanently delete a versioned object if versioning is
      #   configured with MFA delete enabled.
      # @option options [String] :request_payer
      #   Confirms that the requester knows that they will be charged for the
      #   request. Bucket owners need not specify this parameter in their
      #   requests. For information about downloading objects from requester
      #   pays buckets, see [Downloading Objects in Requestor Pays Buckets][1]
      #   in the *Amazon S3 Developer Guide*.
      #
      #
      #
      #   [1]: https://docs.aws.amazon.com/AmazonS3/latest/dev/ObjectsinRequesterPaysBuckets.html
      # @option options [Boolean] :bypass_governance_retention
      #   Specifies whether you want to delete this object even if it has a
      #   Governance-type Object Lock in place. You must have sufficient
      #   permissions to perform this operation.
      # @return [void]
      def batch_delete!(options = {})
        batch_enum.each do |batch|
          params = Aws::Util.copy_hash(options)
          params[:bucket] = batch[0].bucket_name
          params[:delete] ||= {}
          params[:delete][:objects] ||= []
          batch.each do |item|
            params[:delete][:objects] << {
              key: item.key
            }
          end
          batch[0].client.delete_objects(params)
        end
        nil
      end

      # @!endgroup

    end
  end
end
