using Newtonsoft.Json;
using System.ComponentModel.DataAnnotations;


    public class CustomerInformation
    {

        [MaxLength(100)]
        [JsonProperty(NullValueHandling = NullValueHandling.Ignore)]
        public string? Identifier { get; set; }

/// <summary>Email address to recipient.</summary>
        /// <example>someone@example.com</example>
        [MaxLength(100)]
        [JsonProperty(NullValueHandling = NullValueHandling.Ignore)]
        public string? EMail { get; set; }

        /// <summary>Mobile phone number to recipient, for SMS notification. Format: +[countrycode][areacode + number]</summary>
        /// <example>+46764269719</example>
        [MaxLength(50)]
        [JsonProperty(NullValueHandling = NullValueHandling.Ignore)]
        public string? Mobile { get; set; }

        /// <summary>First name of the shipment recipient.</summary>
        /// <example>Anders</example>
        [MaxLength(100)]
        [JsonProperty(NullValueHandling = NullValueHandling.Ignore)]
        public string? FirstName { get; set; }

        /// <summary>Last name of the shipment recipient.</summary>
        /// <example>Svensson</example>
        [MaxLength(100)]
        [JsonProperty(NullValueHandling = NullValueHandling.Ignore)]
        public string? LastName { get; set; }

        /// <summary>Recipient address line 1 of the recipient.</summary>
        /// <example>Torggatan 1</example>
        [MaxLength(300)]
        [JsonProperty(NullValueHandling = NullValueHandling.Ignore)]
        public string? Address1 { get; set; }

        /// <summary>Recipient address line 2 of the recipient.</summary>
        /// <example>Bladgatan 5</example>
        [MaxLength(300)]
        [JsonProperty(NullValueHandling = NullValueHandling.Ignore)]
        public string? Address2 { get; set; }

        /// <summary>Zip code of the recipient.</summary>
        /// <example>21139</example>
        [MaxLength(50)]
        [JsonProperty(NullValueHandling = NullValueHandling.Ignore)]
        public string? ZipCode { get; set; }

        /// <summary>City of the recipient.</summary>
        /// <example>Stockholm</example>
        [MaxLength(100)]
        [JsonProperty(NullValueHandling = NullValueHandling.Ignore)]
        public string? City { get; set; }

        /// <summary>Country code of the recipient (Format: ISO 3361-1 alpha-2). Example: "SE"</summary>
        /// <example>SE</example>
        [MaxLength(2)]
        [JsonProperty(NullValueHandling = NullValueHandling.Ignore)]
        public string? CountryKey { get; set; }

        /// <summary>Language code of the recipient (Format: ISO 3361-1 alpha-2). Example: "SE"</summary>
        /// <example>SE</example>
        [MaxLength(2)]
        [JsonProperty(NullValueHandling = NullValueHandling.Ignore)]
        public string? LanguageKey { get; set; }

        /// <summary>Salutation of the recipient.</summary>
        /// <example>Mrs.</example>
        [MaxLength(50)]
        [JsonProperty(NullValueHandling = NullValueHandling.Ignore)]
        public string? Salutation { get; set; }

        /// <summary>Gender of the shipment recipient. Accepts "M", "F" and "U". M: Male, F: Female, U: Unspecified</summary>
        /// <example>F</example>
        [MaxLength(1)]
        [JsonProperty(NullValueHandling = NullValueHandling.Ignore)]
        public string? Gender { get; set; }

        /// <summary>The access code to the door to get inside the building</summary>
        /// <example>7416E</example>
        [MaxLength(20)]
        [JsonProperty(NullValueHandling = NullValueHandling.Ignore)]
        public string? DoorAccessCode { get; set; }

        [MaxLength(20)]
        [JsonProperty(NullValueHandling = NullValueHandling.Ignore)]
        public int? Birthyear { get; set; }

    }