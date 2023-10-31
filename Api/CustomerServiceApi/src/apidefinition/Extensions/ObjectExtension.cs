    using Newtonsoft.Json;
    public static class ObjectExtension
    {
        public static string SerializeJson(this object objectToSerialize) => JsonConvert.SerializeObject(objectToSerialize);
    }