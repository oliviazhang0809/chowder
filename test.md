# Couchbase Data Model

### 1. Technical Principles
* The models should be taken from the [swagger](https://github.paypal.com/Customers-R/user-platform-serv/tree/develop/spec) definition and represented as scala case classes.
* Couchbase data models will be serialized directly in couch, with a few lookup tables as needed to act as secondary indexes.
* Jackson library is used for serialization/deserialization.
* Full property key names will be serialized instead of abbreviated form.
* For array-type properties, only first/top N elements of the array in couch, further elements are fetched from ASF directly The exact value of N is TBD, though 100 seems reasonable.
* All data values are encrypted via AES/CBC/PKCS5Padding with a 128 bit key. Keys in couch are also hashed using SHA-256. Object values will be serialized json that is AES-128 encrypted.
* There is no partial update in couchbase. Currently UPS will always clear the couch cache, and we'll look to do optimistic concurrency via CAS (check-and-set) operations in the future.

### 2. Data Model

* There will be only one actual couchbase bucket.
* Prefix keys are used to avoid key collisions.
* Version is used as suffix key.
* Table - couchbase key-value pair.

| Prefix  | Key  | Value |
|------|------|------|
| user  | user_id | CouchUser(user: [User](https://github.paypal.com/Customers-R/user-platform-serv/blob/develop/user-platform-serv/src/main/scala/com/paypal/stingray/userplatform/autogen/model/User.scala), privateCreds: Map[String, [PrivateCredential](https://github.paypal.com/Customers-R/user-platform-serv/blob/develop/user-platform-serv/src/main/scala/com/paypal/stingray/userplatform/autogen/model/PrivateCredential.scala)], securityQuestions: Option[[SecurityQuestions](https://github.paypal.com/Customers-R/user-platform-serv/blob/develop/user-platform-serv/src/main/scala/com/paypal/stingray/userplatform/autogen/model/SecurityQuestions.scala)])  |
 | access | user_id | List[[AccountAccess](https://github.paypal.com/Customers-R/user-platform-serv/blob/develop/user-platform-serv/src/main/scala/com/paypal/stingray/userplatform/autogen/model/AccountAccess.scala)] | 
 | userFlag | user_id | [UserFlags](https://github.paypal.com/Customers-R/user-platform-serv/blob/develop/user-platform-serv/src/main/scala/com/paypal/stingray/userplatform/model/UserFlags.scala) | 
 | userProperty | user_id | List[[UserProperty](https://github.paypal.com/Customers-R/user-platform-serv/blob/develop/user-platform-serv/src/main/scala/com/paypal/stingray/userplatform/autogen/model/UserProperty.scala)] | 
 | userUserRelationProperty | user_id | List[[UserToUserRelationProperty](https://github.paypal.com/Customers-R/user-platform-serv/blob/develop/user-platform-serv/src/main/scala/com/paypal/stingray/userplatform/autogen/model/UserToUserRelationProperty.scala)] | 
 | cred | cred_value | List[[AccountAccess](https://github.paypal.com/Customers-R/user-platform-serv/blob/develop/user-platform-serv/src/main/scala/com/paypal/stingray/userplatform/autogen/model/AccountAccess.scala)] | 
 | account | cred_value | List[[Account](https://github.paypal.com/Customers-R/user-platform-serv/blob/develop/user-platform-serv/src/main/scala/com/paypal/stingray/userplatform/autogen/model/Account.scala)] | 
 | account | account_id | [Account](https://github.paypal.com/Customers-R/user-platform-serv/blob/develop/user-platform-serv/src/main/scala/com/paypal/stingray/userplatform/autogen/model/Account.scala) | 
 | credAccount | account_id | accountKey(cred_value) | 
 | multiUser | account_id | List[userId: String] | 
 | fileReference | account_id | List[[FileReference](https://github.paypal.com/Customers-R/user-platform-serv/blob/develop/user-platform-serv/src/main/scala/com/paypal/stingray/userplatform/autogen/model/FileReference.scala)] | 
 | accountFlag | account_id | [AccountFlags](https://github.paypal.com/Customers-R/user-platform-serv/blob/develop/user-platform-serv/src/main/scala/com/paypal/stingray/userplatform/model/AccountFlags.scala) | 
 | accountProperty | account_id | List[[AccountProperty](https://github.paypal.com/Customers-R/user-platform-serv/blob/develop/user-platform-serv/src/main/scala/com/paypal/stingray/userplatform/autogen/model/AccountProperty.scala)] | 

### 3. Cache Invalidation
Following table summarizes all the Create/Update/Delete operations with the associated invalidation events.

| Method  | Prefix  | Key  | Removed Object  | InvalidateAllUserData | Associated Events
|------|------|------|------|------|------|
| invalidateUserToUserRelationProperties  | userUserRelationProperty  | user_id  | List[[UserToUserRelationProperty](https://github.paypal.com/Customers-R/user-platform-serv/blob/develop/user-platform-serv/src/main/scala/com/paypal/stingray/userplatform/autogen/model/UserToUserRelationProperty.scala)]  | √|  |
| invalidateUserProperties  | userProperty  | user_id  | List[[UserProperty](https://github.paypal.com/Customers-R/user-platform-serv/blob/develop/user-platform-serv/src/main/scala/com/paypal/stingray/userplatform/autogen/model/UserProperty.scala)]  | √|  |
| invalidateUserFlagById  | [UserFlags](https://github.paypal.com/Customers-R/user-platform-serv/blob/develop/user-platform-serv/src/main/scala/com/paypal/stingray/userplatform/model/UserFlags.scala)  | user_id  |  [UserFlags](https://github.paypal.com/Customers-R/user-platform-serv/blob/develop/user-platform-serv/src/main/scala/com/paypal/stingray/userplatform/model/UserFlags.scala)  | √|  patchEmailFlagsById patchPartyFlags |
| invalidateUser  | user, multiUser  | user_id  | User, List[List[userId: String]]  | √|   patchAddressMetadata updateAddressMetadata deleteAddress createAddress updateOfficialDateMetadata patchOfficialDateMetadata createOfficialDate patchDocumentIdentifierMetadata updateDocumentIdentifierMetadata deleteDocumentIdentifier createDocumentIdentifier updateEmailMetadata patchEmailMetadata deleteEmail createEmail updateName updatePhoneMetadata patchPhoneMetadata deletePhone createPhone upsertPrivateCredential patchUser updateSecurityQuestions deleteUserToUserRelation createUserToUserRelation
 |
 | invalidateMultiUserResult  | multiUser  | account_id  | List[userId: String]  |  |  |
 | invalidateCredentialByAcctId  | credAccount  | account_id  | List[[Account](https://github.paypal.com/Customers-R/user-platform-serv/blob/develop/user-platform-serv/src/main/scala/com/paypal/stingray/userplatform/autogen/model/Account.scala)]  |  |  |
 | invalidateCredential  | cred, account  | cred_value  | List[[AccountAccess](https://github.paypal.com/Customers-R/user-platform-serv/blob/develop/user-platform-serv/src/main/scala/com/paypal/stingray/userplatform/autogen/model/AccountAccess.scala)], List[[Account](https://github.paypal.com/Customers-R/user-platform-serv/blob/develop/user-platform-serv/src/main/scala/com/paypal/stingray/userplatform/autogen/model/Account.scala)]  | √|  |
 | invalidateAcctFlagById  | accountFlag  | account_id  | [AccountFlags](https://github.paypal.com/Customers-R/user-platform-serv/blob/develop/user-platform-serv/src/main/scala/com/paypal/stingray/userplatform/model/AccountFlags.scala)  |  |  patchAccountFlags |
 | invalidateAccountProperties  | accountProperty  | account_id  | List[[AccountProperty](https://github.paypal.com/Customers-R/user-platform-serv/blob/develop/user-platform-serv/src/main/scala/com/paypal/stingray/userplatform/autogen/model/AccountProperty.scala)]  |  |  |
 | invalidateAccountAccess  | access  | user_id  | List[[AccountAccess](https://github.paypal.com/Customers-R/user-platform-serv/blob/develop/user-platform-serv/src/main/scala/com/paypal/stingray/userplatform/autogen/model/AccountAccess.scala)]  | √|  |
 | invalidateAccount  |  credAccount, account, fileReference, accountFlag, accountPropert  | account_id  |  List[[Account](https://github.paypal.com/Customers-R/user-platform-serv/blob/develop/user-platform-serv/src/main/scala/com/paypal/stingray/userplatform/autogen/model/Account.scala)], [Account](https://github.paypal.com/Customers-R/user-platform-serv/blob/develop/user-platform-serv/src/main/scala/com/paypal/stingray/userplatform/autogen/model/Account.scala), List[[FileReference](https://github.paypal.com/Customers-R/user-platform-serv/blob/develop/user-platform-serv/src/main/scala/com/paypal/stingray/userplatform/autogen/model/FileReference.scala)], [AccountFlags](https://github.paypal.com/Customers-R/user-platform-serv/blob/develop/user-platform-serv/src/main/scala/com/paypal/stingray/userplatform/model/AccountFlags.scala), List[[AccountProperty](https://github.paypal.com/Customers-R/user-platform-serv/blob/develop/user-platform-serv/src/main/scala/com/paypal/stingray/userplatform/autogen/model/AccountProperty.scala)] | √|   upsertLegalAgreement patchAccountMetadata updateAccountMetadata createAccountRelation
|

##### 4. Deployment and Operation
* Test Cluster Setup
    * Our couchbase testing cluster is in the Stingray c3 DEV environment. There are 3 nodes, and the ups tests are configured to run against them.
* Admin UI
    * Host & Port
        * http://couch1-221690.slc01.dev.ebayc3.com:8091/
        * http://couch2-221691.slc01.dev.ebayc3.com:8091/
        * http://couch3-221692.slc01.dev.ebayc3.com:8091/
    * Username: stingray, Password: paypal
* Operational tips
    * If these machines stop working, try a soft reboot from the c3 web ui.

