using AutoMapper;

    public class AutoMapping : Profile
    {
        public AutoMapping()
        {
            CreateMap<CustomerInformation, CanonicalCustomerInformation>();
        }
    }    