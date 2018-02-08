Shader "PBR Master"
{
	Properties
	{
				[NonModifiableTextureData] [NoScaleOffset] Texture_507A46B3("Texture", 2D) = "white" {}
				Vector1_D2D9489B("FresnelPower", Float) = 10
				[NonModifiableTextureData] [NoScaleOffset] Texture_E2350D28("BaseColor", 2D) = "white" {}
				[NonModifiableTextureData] [NoScaleOffset] _Texture2D_3BDAFFBE_Texture("Texture", 2D) = "white" {}
				[NonModifiableTextureData] [NoScaleOffset] _Texture2D_43A49A96_Texture("Texture", 2D) = "white" {}
		
	}
	SubShader
	{
		Tags{ "RenderPipeline" = "LightweightPipeline"}
		Tags
		{
			"RenderType"="Opaque"
			"Queue"="Geometry"
		}
		
		Pass
{
	Tags{"LightMode" = "LightweightForward"}
	
			Blend One Zero
		
			Cull Back
		
			ZTest LEqual
		
			ZWrite On
		

	HLSLPROGRAM
    // Required to compile gles 2.0 with standard srp library
    #pragma prefer_hlslcc gles
	#pragma target 3.0

    // -------------------------------------
    // Lightweight Pipeline keywords
    // We have no good approach exposed to skip shader variants, e.g, ideally we would like to skip _CASCADE for all puctual lights
    // Lightweight combines light classification and shadows keywords to reduce shader variants.
    // Lightweight shader library declares defines based on these keywords to avoid having to check them in the shaders
    // Core.hlsl defines _MAIN_LIGHT_DIRECTIONAL and _MAIN_LIGHT_SPOT (point lights can't be main light)
    // Shadow.hlsl defines _SHADOWS_ENABLED, _SHADOWS_SOFT, _SHADOWS_CASCADE, _SHADOWS_PERSPECTIVE
    #pragma multi_compile _ _MAIN_LIGHT_DIRECTIONAL_SHADOW _MAIN_LIGHT_DIRECTIONAL_SHADOW_CASCADE _MAIN_LIGHT_DIRECTIONAL_SHADOW_SOFT _MAIN_LIGHT_DIRECTIONAL_SHADOW_CASCADE_SOFT _MAIN_LIGHT_SPOT_SHADOW _MAIN_LIGHT_SPOT_SHADOW_SOFT
    #pragma multi_compile _ _MAIN_LIGHT_COOKIE
    #pragma multi_compile _ _ADDITIONAL_LIGHTS
    #pragma multi_compile _ _VERTEX_LIGHTS
    #pragma multi_compile _ _MIXED_LIGHTING_SUBTRACTIVE
    #pragma multi_compile _ FOG_LINEAR FOG_EXP2

    // -------------------------------------
    // Unity defined keywords
    #pragma multi_compile _ UNITY_SINGLE_PASS_STEREO STEREO_INSTANCING_ON STEREO_MULTIVIEW_ON
    #pragma multi_compile _ DIRLIGHTMAP_COMBINED LIGHTMAP_ON

    //--------------------------------------
    // GPU Instancing
    #pragma multi_compile_instancing

    // LW doesn't support dynamic GI. So we save 30% shader variants if we assume
    // LIGHTMAP_ON when DIRLIGHTMAP_COMBINED is set
    #ifdef DIRLIGHTMAP_COMBINED
    #define LIGHTMAP_ON
    #endif

    #pragma vertex vert
	#pragma fragment frag

				#define _NORMALMAP 1
		

	#include "LWRP/ShaderLibrary/Core.hlsl"
	#include "LWRP/ShaderLibrary/Lighting.hlsl"
	#include "CoreRP/ShaderLibrary/Color.hlsl"
	#include "CoreRP/ShaderLibrary/UnityInstancing.hlsl"
	#include "ShaderGraphLibrary/Functions.hlsl"

						TEXTURE2D(Texture_507A46B3); SAMPLER(samplerTexture_507A46B3);
							float Vector1_D2D9489B;
							TEXTURE2D(Texture_E2350D28); SAMPLER(samplerTexture_E2350D28);
							float4 _NormalCreate_8B6271FA_UV;
							float _NormalCreate_8B6271FA_Offset;
							float _NormalCreate_8B6271FA_Strength;
							float Vector1_FA7B64E2;
							float4 _Texture2D_CE7FDB22_UV;
							float _Add_955670F1_B;
							float _Combine_76C873_G;
							float _Combine_76C873_B;
							float _Combine_76C873_A;
							float _Multiply_77943E40_B;
							float _Subtract_4053AE6C_A;
							float _Combine_EBDC57C5_G;
							float _Combine_EBDC57C5_B;
							float _Combine_EBDC57C5_A;
							float Vector1_A9FE7B6C;
							TEXTURE2D(_Texture2D_3BDAFFBE_Texture); SAMPLER(sampler_Texture2D_3BDAFFBE_Texture);
							float4 _Texture2D_3BDAFFBE_UV;
							float4 _Texture2D_63B21599_UV;
							float _Power_8AAB91A9_B;
							float _Multiply_9DFBFF7B_B;
							float4 _Hue_6D737DC1_In;
							float Vector1_1781D992;
							float4 Vector3_88660F88;
							float Vector1_91963E7E;
							float4 _Remap_49700E8_InMinMax;
							float4 _Remap_49700E8_OutMinMax;
							TEXTURE2D(_Texture2D_43A49A96_Texture); SAMPLER(sampler_Texture2D_43A49A96_Texture);
							float4 _Texture2D_43A49A96_UV;
							float4 _Remap_4DA15C85_InMinMax;
							float4 _Remap_4DA15C85_OutMinMax;
							float _PBRMaster_F7F4F02F_Metallic;
							float _PBRMaster_F7F4F02F_Alpha;
							float _PBRMaster_F7F4F02F_AlphaClipThreshold;
					
							struct SurfaceInputs{
								float3 ObjectSpaceNormal;
								float3 ObjectSpaceTangent;
								float3 ObjectSpaceBiTangent;
								float3 TangentSpaceViewDirection;
								half4 uv0;
							};
					
					
					        void Unity_NormalCreate_float(Texture2D Texture, SamplerState Sampler, float2 UV, float Offset, float Strength, out float3 Out)
					        {
					            Offset = pow(Offset, 3) * 0.1;
					            float2 offsetU = float2(UV.x + Offset, UV.y);
					            float2 offsetV = float2(UV.x, UV.y + Offset);
					            float normalSample = Texture.Sample(Sampler, UV);
					            float uSample = Texture.Sample(Sampler, offsetU);
					            float vSample = Texture.Sample(Sampler, offsetV);
					            float3 va = float3(1, 0, (uSample - normalSample) * Strength);
					            float3 vb = float3(0, 1, (vSample - normalSample) * Strength);
					            Out = normalize(cross(va, vb));
					        }
					
					        void Unity_FresnelEffect_float(float3 Normal, float3 ViewDir, float Power, out float Out)
					        {
					            Out = pow((1.0 - saturate(dot(normalize(Normal), normalize(ViewDir)))), Power);
					        }
					
					        void Unity_Multiply_float(float A, float B, out float Out)
					        {
					            Out = A * B;
					        }
					
					        void Unity_Add_float(float A, float B, out float Out)
					        {
					            Out = A + B;
					        }
					
					        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA)
					        {
					            RGBA = float4(R, G, B, A);
					        }
					
					        void Unity_Multiply_float4(float4 A, float4 B, out float4 Out)
					        {
					            Out = A * B;
					        }
					
					        void Unity_ColorspaceConversion_HSV_RGB_float(float3 In, out float3 Out)
					        {
					            float4 K = float4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
					            float3 P = abs(frac(In.xxx + K.xyz) * 6.0 - K.www);
					            Out = In.z * lerp(K.xxx, saturate(P - K.xxx), In.y);
					        }
					
					        void Unity_OneMinus_float(float In, out float Out)
					        {
					            Out = 1 - In;
					        }
					
					        void Unity_Subtract_float(float A, float B, out float Out)
					        {
					            Out = A - B;
					        }
					
					        void Unity_Multiply_float3(float3 A, float3 B, out float3 Out)
					        {
					            Out = A * B;
					        }
					
					        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
					        {
					            Out = A + B;
					        }
					
					        void Unity_Power_float(float A, float B, out float Out)
					        {
					            Out = pow(A, B);
					        }
					
					        void Unity_Hue_Normalized_float(float3 In, float Offset, out float3 Out)
					        {
					            // RGB to HSV
					            float4 K = float4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
					            float4 P = lerp(float4(In.bg, K.wz), float4(In.gb, K.xy), step(In.b, In.g));
					            float4 Q = lerp(float4(P.xyw, In.r), float4(In.r, P.yzx), step(P.x, In.r));
					            float D = Q.x - min(Q.w, Q.y);
					            float E = 1e-10;
					            float3 hsv = float3(abs(Q.z + (Q.w - Q.y)/(6.0 * D + E)), D / (Q.x + E), Q.x);
					
					            float hue = hsv.x + Offset;
					            hsv.x = (hue < 0)
					                    ? hue + 1
					                    : (hue > 1)
					                        ? hue - 1
					                        : hue;
					
					            // HSV to RGB
					            float4 K2 = float4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
					            float3 P2 = abs(frac(hsv.xxx + K2.xyz) * 6.0 - K2.www);
					            Out = hsv.z * lerp(K2.xxx, saturate(P2 - K2.xxx), hsv.y);
					        }
					
					        void Unity_Power_float3(float3 A, float3 B, out float3 Out)
					        {
					            Out = pow(A, B);
					        }
					
					        void Unity_Divide_float3(float3 A, float3 B, out float3 Out)
					        {
					            Out = A / B;
					        }
					
					        void Unity_Reciprocal_float(float In, out float Out)
					        {
					            Out = 1.0/In;
					        }
					
					        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
					        {
					            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
					        }
					
							struct GraphVertexInput
							{
								float4 vertex : POSITION;
								float3 normal : NORMAL;
								float4 tangent : TANGENT;
								float4 texcoord0 : TEXCOORD0;
								float4 texcoord1 : TEXCOORD1;
								UNITY_VERTEX_INPUT_INSTANCE_ID
							};
					
							struct SurfaceDescription{
								float3 Albedo;
								float3 Normal;
								float3 Emission;
								float Metallic;
								float Smoothness;
								float Occlusion;
								float Alpha;
								float AlphaClipThreshold;
							};
					
							GraphVertexInput PopulateVertexData(GraphVertexInput v){
								return v;
							}
					
							SurfaceDescription PopulateSurfaceData(SurfaceInputs IN) {
								SurfaceDescription surface = (SurfaceDescription)0;
								float3 _NormalCreate_8B6271FA_Out;
								Unity_NormalCreate_float(Texture_507A46B3, samplerTexture_507A46B3, IN.uv0.xy, _NormalCreate_8B6271FA_Offset, _NormalCreate_8B6271FA_Strength, _NormalCreate_8B6271FA_Out);
								
								float _Property_DEDFE7DB_Out = Vector1_D2D9489B;
								float _FresnelEffect_F1C111ED_Out;
								Unity_FresnelEffect_float(_NormalCreate_8B6271FA_Out, IN.TangentSpaceViewDirection, _Property_DEDFE7DB_Out, _FresnelEffect_F1C111ED_Out);
								float _Multiply_CC88C9FE_Out;
								Unity_Multiply_float(_FresnelEffect_F1C111ED_Out, Vector1_FA7B64E2, _Multiply_CC88C9FE_Out);
								float4 _Texture2D_CE7FDB22_RGBA = SAMPLE_TEXTURE2D(Texture_507A46B3, samplerTexture_507A46B3, IN.uv0.xy);
								float _Texture2D_CE7FDB22_R = _Texture2D_CE7FDB22_RGBA.r;
								float _Texture2D_CE7FDB22_G = _Texture2D_CE7FDB22_RGBA.g;
								float _Texture2D_CE7FDB22_B = _Texture2D_CE7FDB22_RGBA.b;
								float _Texture2D_CE7FDB22_A = _Texture2D_CE7FDB22_RGBA.a;
								float _Add_955670F1_Out;
								Unity_Add_float(_SinTime.w, _Add_955670F1_B, _Add_955670F1_Out);
								float4 _Combine_76C873_RGBA;
								Unity_Combine_float(_Add_955670F1_Out, _Combine_76C873_G, _Combine_76C873_B, _Combine_76C873_A, _Combine_76C873_RGBA);
								float4 _Multiply_89C71AC1_Out;
								Unity_Multiply_float4(_Texture2D_CE7FDB22_RGBA, _Combine_76C873_RGBA, _Multiply_89C71AC1_Out);
								float3 _ColorspaceConversion_3570283C_Out;
								Unity_ColorspaceConversion_HSV_RGB_float((_Multiply_89C71AC1_Out.xyz), _ColorspaceConversion_3570283C_Out);
								float _Split_81BA869A_R = _ColorspaceConversion_3570283C_Out[0];
								float _Split_81BA869A_G = _ColorspaceConversion_3570283C_Out[1];
								float _Split_81BA869A_B = _ColorspaceConversion_3570283C_Out[2];
								float _Split_81BA869A_A = 0;
								float _Multiply_9164EC34_Out;
								Unity_Multiply_float(_Split_81BA869A_R, _Split_81BA869A_G, _Multiply_9164EC34_Out);
								float _Multiply_841C266E_Out;
								Unity_Multiply_float(_Multiply_9164EC34_Out, _Split_81BA869A_B, _Multiply_841C266E_Out);
								float _Multiply_77943E40_Out;
								Unity_Multiply_float(_Multiply_841C266E_Out, _Multiply_77943E40_B, _Multiply_77943E40_Out);
								float _OneMinus_F47415CA_Out;
								Unity_OneMinus_float(_Multiply_77943E40_Out, _OneMinus_F47415CA_Out);
								float _Subtract_4053AE6C_Out;
								Unity_Subtract_float(_Subtract_4053AE6C_A, _CosTime.w, _Subtract_4053AE6C_Out);
								float4 _Combine_EBDC57C5_RGBA;
								Unity_Combine_float(_Subtract_4053AE6C_Out, _Combine_EBDC57C5_G, _Combine_EBDC57C5_B, _Combine_EBDC57C5_A, _Combine_EBDC57C5_RGBA);
								float3 _ColorspaceConversion_C8F0BBD5_Out;
								Unity_ColorspaceConversion_HSV_RGB_float((_Combine_EBDC57C5_RGBA.xyz), _ColorspaceConversion_C8F0BBD5_Out);
								float3 _Multiply_E8E6BAEA_Out;
								Unity_Multiply_float3((_OneMinus_F47415CA_Out.xxx), _ColorspaceConversion_C8F0BBD5_Out, _Multiply_E8E6BAEA_Out);
								float3 _Multiply_156218A9_Out;
								Unity_Multiply_float3((_Multiply_CC88C9FE_Out.xxx), _Multiply_E8E6BAEA_Out, _Multiply_156218A9_Out);
								float3 _Multiply_F77E48F9_Out;
								Unity_Multiply_float3(_ColorspaceConversion_3570283C_Out, (Vector1_A9FE7B6C.xxx), _Multiply_F77E48F9_Out);
								float4 _Texture2D_3BDAFFBE_RGBA = SAMPLE_TEXTURE2D(_Texture2D_3BDAFFBE_Texture, sampler_Texture2D_3BDAFFBE_Texture, IN.uv0.xy);
								float _Texture2D_3BDAFFBE_R = _Texture2D_3BDAFFBE_RGBA.r;
								float _Texture2D_3BDAFFBE_G = _Texture2D_3BDAFFBE_RGBA.g;
								float _Texture2D_3BDAFFBE_B = _Texture2D_3BDAFFBE_RGBA.b;
								float _Texture2D_3BDAFFBE_A = _Texture2D_3BDAFFBE_RGBA.a;
								float3 _Multiply_5F49F55E_Out;
								Unity_Multiply_float3(_Multiply_F77E48F9_Out, (_Texture2D_3BDAFFBE_RGBA.xyz), _Multiply_5F49F55E_Out);
								float3 _Add_A93EC3AF_Out;
								Unity_Add_float3(_Multiply_156218A9_Out, _Multiply_5F49F55E_Out, _Add_A93EC3AF_Out);
								float4 _Texture2D_63B21599_RGBA = SAMPLE_TEXTURE2D(Texture_507A46B3, samplerTexture_507A46B3, IN.uv0.xy);
								float _Texture2D_63B21599_R = _Texture2D_63B21599_RGBA.r;
								float _Texture2D_63B21599_G = _Texture2D_63B21599_RGBA.g;
								float _Texture2D_63B21599_B = _Texture2D_63B21599_RGBA.b;
								float _Texture2D_63B21599_A = _Texture2D_63B21599_RGBA.a;
								float _OneMinus_D38B6E7C_Out;
								Unity_OneMinus_float(_Texture2D_63B21599_R, _OneMinus_D38B6E7C_Out);
								float _Power_8AAB91A9_Out;
								Unity_Power_float(_OneMinus_D38B6E7C_Out, _Power_8AAB91A9_B, _Power_8AAB91A9_Out);
								float _Multiply_9DFBFF7B_Out;
								Unity_Multiply_float(_Time.y, _Multiply_9DFBFF7B_B, _Multiply_9DFBFF7B_Out);
								float3 _Hue_6D737DC1_Out;
								Unity_Hue_Normalized_float(_Hue_6D737DC1_In, _Multiply_9DFBFF7B_Out, _Hue_6D737DC1_Out);
								float3 _Power_C4E20D3B_Out;
								Unity_Power_float3(_Hue_6D737DC1_Out, (Vector1_1781D992.xxx), _Power_C4E20D3B_Out);
								float3 _Divide_B0B110CE_Out;
								Unity_Divide_float3(_Power_C4E20D3B_Out, Vector3_88660F88, _Divide_B0B110CE_Out);
								float _Reciprocal_93F3D817_Out;
								Unity_Reciprocal_float(Vector1_1781D992, _Reciprocal_93F3D817_Out);
								float3 _Power_E77DC98F_Out;
								Unity_Power_float3(_Divide_B0B110CE_Out, (_Reciprocal_93F3D817_Out.xxx), _Power_E77DC98F_Out);
								float3 _Multiply_731F83FC_Out;
								Unity_Multiply_float3(_Power_E77DC98F_Out, (Vector1_91963E7E.xxx), _Multiply_731F83FC_Out);
								float _Remap_49700E8_Out;
								Unity_Remap_float(_SinTime.w, _Remap_49700E8_InMinMax, _Remap_49700E8_OutMinMax, _Remap_49700E8_Out);
								float3 _Multiply_D447D798_Out;
								Unity_Multiply_float3(_Multiply_731F83FC_Out, (_Remap_49700E8_Out.xxx), _Multiply_D447D798_Out);
								float3 _Multiply_3760727D_Out;
								Unity_Multiply_float3((_Power_8AAB91A9_Out.xxx), _Multiply_D447D798_Out, _Multiply_3760727D_Out);
								float4 _Texture2D_43A49A96_RGBA = SAMPLE_TEXTURE2D(_Texture2D_43A49A96_Texture, sampler_Texture2D_43A49A96_Texture, IN.uv0.xy);
								float _Texture2D_43A49A96_R = _Texture2D_43A49A96_RGBA.r;
								float _Texture2D_43A49A96_G = _Texture2D_43A49A96_RGBA.g;
								float _Texture2D_43A49A96_B = _Texture2D_43A49A96_RGBA.b;
								float _Texture2D_43A49A96_A = _Texture2D_43A49A96_RGBA.a;
								float _Remap_4DA15C85_Out;
								Unity_Remap_float(_Power_8AAB91A9_Out, _Remap_4DA15C85_InMinMax, _Remap_4DA15C85_OutMinMax, _Remap_4DA15C85_Out);
								surface.Albedo = _Add_A93EC3AF_Out;
								surface.Normal = _NormalCreate_8B6271FA_Out;
								surface.Emission = _Multiply_3760727D_Out;
								surface.Metallic = _PBRMaster_F7F4F02F_Metallic;
								surface.Smoothness = _Texture2D_43A49A96_R;
								surface.Occlusion = _Remap_4DA15C85_Out;
								surface.Alpha = _PBRMaster_F7F4F02F_Alpha;
								surface.AlphaClipThreshold = _PBRMaster_F7F4F02F_AlphaClipThreshold;
								return surface;
							}
					
		

	struct GraphVertexOutput
    {
        float4 clipPos                : SV_POSITION;
        float4 lightmapUVOrVertexSH   : TEXCOORD0;
		half4 fogFactorAndVertexLight : TEXCOORD1; // x: fogFactor, yzw: vertex light
    	float4 shadowCoord            : TEXCOORD2;
        			float3 WorldSpaceNormal : TEXCOORD3;
					float3 WorldSpaceTangent : TEXCOORD4;
					float3 WorldSpaceBiTangent : TEXCOORD5;
					float3 WorldSpaceViewDirection : TEXCOORD6;
					float3 WorldSpacePosition : TEXCOORD7;
					half4 uv0 : TEXCOORD8;
					half4 uv1 : TEXCOORD9;
		
        UNITY_VERTEX_INPUT_INSTANCE_ID
    };

    GraphVertexOutput vert (GraphVertexInput v)
	{
	    v = PopulateVertexData(v);

        GraphVertexOutput o = (GraphVertexOutput)0;

        UNITY_SETUP_INSTANCE_ID(v);
    	UNITY_TRANSFER_INSTANCE_ID(v, o);

        			o.WorldSpaceNormal = mul(v.normal,(float3x3)UNITY_MATRIX_I_M);
					o.WorldSpaceTangent = mul((float3x3)UNITY_MATRIX_M,v.tangent);
					o.WorldSpaceBiTangent = normalize(cross(o.WorldSpaceNormal, o.WorldSpaceTangent.xyz) * v.tangent.w);
					o.WorldSpaceViewDirection = SafeNormalize(_WorldSpaceCameraPos.xyz - mul(GetObjectToWorldMatrix(), float4(v.vertex.xyz, 1.0)).xyz);
					o.WorldSpacePosition = mul(UNITY_MATRIX_M,v.vertex);
					o.uv0 = v.texcoord0;
					o.uv1 = v.texcoord1;
		

		float3 lwWNormal = TransformObjectToWorldNormal(v.normal);
		float3 lwWorldPos = TransformObjectToWorld(v.vertex.xyz);
		float4 clipPos = TransformWorldToHClip(lwWorldPos);

 		// We either sample GI from lightmap or SH. lightmap UV and vertex SH coefficients
	    // are packed in lightmapUVOrVertexSH to save interpolator.
	    // The following funcions initialize
	    OUTPUT_LIGHTMAP_UV(v.texcoord1, unity_LightmapST, o.lightmapUVOrVertexSH);
	    OUTPUT_SH(lwWNormal, o.lightmapUVOrVertexSH);

	    half3 vertexLight = VertexLighting(lwWorldPos, lwWNormal);
	    half fogFactor = ComputeFogFactor(clipPos.z);
	    o.fogFactorAndVertexLight = half4(fogFactor, vertexLight);
	    o.clipPos = clipPos;

#if defined(_SHADOWS_ENABLED) && !defined(_SHADOWS_CASCADE)
	    o.shadowCoord = ComputeShadowCoord(lwWorldPos);
#else
		o.shadowCoord = float4(0, 0, 0, 0);
#endif

		return o;
	}

	half4 frag (GraphVertexOutput IN) : SV_Target
    {
    	UNITY_SETUP_INSTANCE_ID(IN);

    				float3 WorldSpaceNormal = normalize(IN.WorldSpaceNormal);
					float3 WorldSpaceTangent = IN.WorldSpaceTangent;
					float3 WorldSpaceBiTangent = IN.WorldSpaceBiTangent;
					float3 WorldSpaceViewDirection = normalize(IN.WorldSpaceViewDirection);
					float3 WorldSpacePosition = IN.WorldSpacePosition;
					float3x3 tangentSpaceTransform = float3x3(WorldSpaceTangent,WorldSpaceBiTangent,WorldSpaceNormal);
					float3 ObjectSpaceNormal = mul(WorldSpaceNormal,(float3x3)UNITY_MATRIX_M);
					float3 ObjectSpaceTangent = mul((float3x3)UNITY_MATRIX_I_M,WorldSpaceTangent);
					float3 ObjectSpaceBiTangent = mul((float3x3)UNITY_MATRIX_I_M,WorldSpaceBiTangent);
					float3 TangentSpaceViewDirection = mul(WorldSpaceViewDirection,(float3x3)tangentSpaceTransform);
					float4 uv0 = IN.uv0;
					float4 uv1 = IN.uv1;
		

        SurfaceInputs surfaceInput = (SurfaceInputs)0;
        			surfaceInput.ObjectSpaceNormal = ObjectSpaceNormal;
					surfaceInput.ObjectSpaceTangent = ObjectSpaceTangent;
					surfaceInput.ObjectSpaceBiTangent = ObjectSpaceBiTangent;
					surfaceInput.TangentSpaceViewDirection = TangentSpaceViewDirection;
					surfaceInput.uv0 = uv0;
		

        SurfaceDescription surf = PopulateSurfaceData(surfaceInput);

		float3 Albedo = float3(0.5, 0.5, 0.5);
		float3 Specular = float3(0, 0, 0);
		float Metallic = 1;
		float3 Normal = float3(0, 0, 1);
		float3 Emission = 0;
		float Smoothness = 0.5;
		float Occlusion = 1;
		float Alpha = 1;
		float AlphaClipThreshold = 0;

        			Albedo = surf.Albedo;
					Normal = surf.Normal;
					Emission = surf.Emission;
					Metallic = surf.Metallic;
					Smoothness = surf.Smoothness;
					Occlusion = surf.Occlusion;
					Alpha = surf.Alpha;
					AlphaClipThreshold = surf.AlphaClipThreshold;
		

		InputData inputData;
		inputData.positionWS = WorldSpacePosition;

#ifdef _NORMALMAP
	    inputData.normalWS = TangentToWorldNormal(Normal, WorldSpaceTangent, WorldSpaceBiTangent, WorldSpaceNormal);
#else
	    inputData.normalWS = normalize(WorldSpaceNormal);
#endif

#ifdef SHADER_API_MOBILE
	    // viewDirection should be normalized here, but we avoid doing it as it's close enough and we save some ALU.
	    inputData.viewDirectionWS = WorldSpaceViewDirection;
#else
	    inputData.viewDirectionWS = normalize(WorldSpaceViewDirection);
#endif

#ifdef _SHADOWS_ENABLED
	    inputData.shadowCoord = IN.shadowCoord;
#else
	    inputData.shadowCoord = float4(0, 0, 0, 0);
#endif

	    inputData.fogCoord = IN.fogFactorAndVertexLight.x;
	    inputData.vertexLighting = IN.fogFactorAndVertexLight.yzw;
	    inputData.bakedGI = SampleGI(IN.lightmapUVOrVertexSH, inputData.normalWS);

		half4 color = LightweightFragmentPBR(
			inputData, 
			Albedo, 
			Metallic, 
			Specular, 
			Smoothness, 
			Occlusion, 
			Emission, 
			Alpha);

		// Computes fog factor per-vertex
    	ApplyFog(color.rgb, IN.fogFactorAndVertexLight.x);

#if _AlphaClip
		clip(Alpha - AlphaClipThreshold);
#endif
		return color;
    }

	ENDHLSL
}

		Pass
{
    Tags{"LightMode" = "ShadowCaster"}

    ZWrite On ZTest LEqual

    HLSLPROGRAM
    // Required to compile gles 2.0 with standard srp library
    #pragma prefer_hlslcc gles
    #pragma target 2.0

    //--------------------------------------
    // GPU Instancing
    #pragma multi_compile_instancing

    #pragma vertex ShadowPassVertex
    #pragma fragment ShadowPassFragment

    #include "LWRP/ShaderLibrary/LightweightPassShadow.hlsl"
    ENDHLSL
}

Pass
{
    Tags{"LightMode" = "DepthOnly"}

    ZWrite On
    ColorMask 0

    HLSLPROGRAM
    // Required to compile gles 2.0 with standard srp library
    #pragma prefer_hlslcc gles
    #pragma target 2.0
    #pragma vertex vert
    #pragma fragment frag

    #include "LWRP/ShaderLibrary/Core.hlsl"

    float4 vert(float4 pos : POSITION) : SV_POSITION
    {
        return TransformObjectToHClip(pos.xyz);
    }

    half4 frag() : SV_TARGET
    {
        return 0;
    }
    ENDHLSL
}

// This pass it not used during regular rendering, only for lightmap baking.
Pass
{
    Tags{"LightMode" = "Meta"}

    Cull Off

    HLSLPROGRAM
    // Required to compile gles 2.0 with standard srp library
    #pragma prefer_hlslcc gles

    #pragma vertex LightweightVertexMeta
    #pragma fragment LightweightFragmentMeta

    #pragma shader_feature _SPECULAR_SETUP
    #pragma shader_feature _EMISSION
    #pragma shader_feature _METALLICSPECGLOSSMAP
    #pragma shader_feature _ _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A
    #pragma shader_feature EDITOR_VISUALIZATION

    #pragma shader_feature _SPECGLOSSMAP

    #include "LWRP/ShaderLibrary/LightweightPassMeta.hlsl"
    ENDHLSL
}
	}
	
}
