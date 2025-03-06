import { IsEmail, isEmail, IsNumber, IsPositive, MinLength } from "class-validator";

export class CreateCustomerDto {

    @IsNumber()
    @IsPositive()
    id: number;

    @IsNumber()
    @IsPositive()
    national_id: number;

    @MinLength(3)
    name: string;

    @MinLength(3)
    lastname: string;

    @MinLength(3)
    @IsEmail()
    email: string;
    
}
